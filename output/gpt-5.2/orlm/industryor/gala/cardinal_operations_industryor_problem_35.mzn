include "globals.mzn";

/*
  VRP with Hard Time Windows (VRPHTW)
  - 1 depot (node 0), 20 customers (1..20)
  - up to 5 vehicles, capacity 200
  - fixed service time 90 at each customer (0 at depot)
  - hard time windows: service must start within [ready, due]
  - vehicles start and end at depot
  - objective: minimize total travel distance
*/

%----------------------- DATA (embedded) -----------------------%
int: nCust = 20;
int: nNodes = nCust + 1;              % nodes 0..20
set of int: NODES = 0..nCust;
set of int: CUST  = 1..nCust;

int: K = 5;                           % max vehicles
set of int: VEH = 1..K;

int: Q = 200;                         % capacity
int: service_time = 90;

array[NODES] of int: x = [
  40,  % 0 depot
  45,45,42,42,42,40,40,38,38,35,35,25,22,22,20,20,18,15,15,30
];
array[NODES] of int: y = [
  50,  % 0 depot
  68,70,66,68,65,69,66,68,70,66,69,85,75,85,80,85,75,75,80,50
];

array[NODES] of int: demand = [
  0,   % depot
  10,30,10,10,10,20,20,20,10,10,10,20,30,10,40,40,20,20,10,10
];

array[NODES] of int: ready = [
  0,    % depot
  912,825,65,727,15,621,170,255,534,357,448,652,30,567,384,475,99,179,278,10
];
array[NODES] of int: due = [
  1236, % depot
  967,870,146,782,67,702,225,324,605,410,505,721,92,620,429,528,148,254,345,73
];

array[NODES] of int: service = [ if i=0 then 0 else service_time endif | i in NODES ];

% Distance as rounded-up Euclidean integer (keeps model linear-ish and integral)
function int: dist_int(int: i, int: j) =
  ceil(sqrt( int2float((x[i]-x[j])*(x[i]-x[j]) + (y[i]-y[j])*(y[i]-y[j])) ));

array[NODES, NODES] of int: dist = array2d(NODES, NODES,
  [ dist_int(i,j) | i in NODES, j in NODES ]
);

int: BIGT = 100000;  % sufficiently large

%----------------------- DECISIONS -----------------------%
% successor of each node for each vehicle: next[k,i] in NODES
array[VEH, NODES] of var NODES: next;

% which vehicle serves customer i (0 means unserved, but we force served)
array[CUST] of var VEH: veh_of;

% position index along route (for subtour elimination) per vehicle
array[VEH, NODES] of var 0..nCust: pos;

% service start times per vehicle and node (only meaningful if visited by that vehicle)
array[VEH, NODES] of var 0..BIGT: start;

% indicator: served by vehicle k
array[VEH, CUST] of var bool: served;

% used vehicle flag (whether it leaves depot to a customer)
array[VEH] of var bool: used;

%----------------------- LINKING: assignment <-> arcs -----------------------%
constraint forall(i in CUST)(
  sum(k in VEH)(bool2int(served[k,i])) = 1
);

constraint forall(k in VEH, i in CUST)(
  served[k,i] <-> (veh_of[i] = k)
);

% Each customer has exactly one outgoing arc (from the vehicle that serves it), others self-loop
constraint forall(i in CUST)(
  exists(k in VEH)( next[k,i] != i ) /\
  sum(k in VEH)( bool2int(next[k,i] != i) ) = 1
);

% If customer i served by k then k must not self-loop on i; if not served then self-loop
constraint forall(k in VEH, i in CUST)(
  served[k,i] -> next[k,i] != i
);
constraint forall(k in VEH, i in CUST)(
  not served[k,i] -> next[k,i] = i
);

% For each vehicle, depot either self-loops (unused) or goes to a first customer
constraint forall(k in VEH)(
  (next[k,0] = 0) \/ (next[k,0] in CUST)
);

constraint forall(k in VEH)(
  used[k] <-> (next[k,0] != 0)
);

% Each vehicle: exactly one node points to depot if used; none if unused
constraint forall(k in VEH)(
  sum(i in CUST)( bool2int(next[k,i] = 0) ) = bool2int(used[k])
);

% Flow conservation on customers for each vehicle:
% if served by k then exactly one predecessor on that vehicle; else none.
constraint forall(k in VEH, j in CUST)(
  sum(i in NODES)( bool2int(next[k,i] = j) ) = bool2int(served[k,j])
);

% No direct 0->0 if used, handled by used[k], but keep consistent:
constraint forall(k in VEH)(
  next[k,0] = 0 <-> not used[k]
);

%----------------------- SUBTOUR ELIMINATION (MTZ-like with pos) -----------------------%
% depot position is 0
constraint forall(k in VEH)( pos[k,0] = 0 );

% Served customers have position 1..nCust on that vehicle; unserved are 0
constraint forall(k in VEH, i in CUST)(
  served[k,i] -> pos[k,i] >= 1
);
constraint forall(k in VEH, i in CUST)(
  not served[k,i] -> pos[k,i] = 0
);

% If arc i->j is used on vehicle k (with j not depot and i not depot),
% then pos[j] = pos[i] + 1 (enforces single tour starting from depot, no cycles)
constraint forall(k in VEH, i in CUST, j in CUST where i != j)(
  (next[k,i] = j) -> (pos[k,j] = pos[k,i] + 1)
);

% First customer after depot must have position 1
constraint forall(k in VEH, j in CUST)(
  (next[k,0] = j) -> (pos[k,j] = 1)
);

%----------------------- CAPACITY CONSTRAINTS -----------------------%
constraint forall(k in VEH)(
  sum(i in CUST)( demand[i] * bool2int(served[k,i]) ) <= Q
);

%----------------------- TIME WINDOW + PRECEDENCE -----------------------%
% Enforce time windows for served customers (service start within window)
constraint forall(k in VEH, i in CUST)(
  served[k,i] -> (start[k,i] >= ready[i] /\ start[k,i] <= due[i])
);

% Depot start time within depot window (can be 0); keep within due
constraint forall(k in VEH)(
  start[k,0] >= ready[0] /\ start[k,0] <= due[0]
);

% Travel-time precedence with waiting allowed:
% if i -> j on vehicle k (including from depot and to customers),
% then start[j] >= start[i] + service[i] + dist[i,j]
constraint forall(k in VEH, i in NODES, j in CUST where i != j)(
  (next[k,i] = j) -> (start[k,j] >= start[k,i] + service[i] + dist[i,j])
);

% If i -> depot, ensure return within depot time window end (hard)
constraint forall(k in VEH, i in CUST)(
  (next[k,i] = 0) -> (start[k,0] >= start[k,i] + service[i] + dist[i,0])
);

% Unserved customer time values irrelevant; keep bounded to reduce symmetry a bit
constraint forall(k in VEH, i in CUST)(
  not served[k,i] -> start[k,i] = 0
);

% Symmetry breaking: used vehicles are packed first
constraint forall(k in 1..K-1)( used[k] >= used[k+1] );

%----------------------- OBJECTIVE -----------------------%
var int: total_distance =
  sum(k in VEH, i in NODES)( dist[i, next[k,i]] );

solve minimize total_distance;

%----------------------- OUTPUT -----------------------%
function string: route_str(int: k) =
  if fix(used[k]) = 0 then
    "Vehicle " ++ show(k) ++ ": unused\n"
  else
    let {
      int: maxSteps = nCust + 2
    } in
    "Vehicle " ++ show(k) ++ ": " ++
    concat([ if s=1 then "0" else "" endif ++
             " -> " ++ show( fix( if s=1 then next[k,0]
                                  else next[k, fix( if s=2 then next[k,0] else
                                                   next[k, fix( if s=3 then next[k, next[k,0]] else
                                                                next[k,0] endif ) ] endif ) ])
                           ) )
           | s in 1..0 ]) % placeholder, replaced below
  endif;

% Custom, clearer route printing by following next pointers
function string: show_route(int: k) =
  if fix(used[k]) = 0 then
    "Vehicle " ++ show(k) ++ ": 0 -> 0\n"
  else
    let {
      int: maxSteps = nCust + 2
    } in
    "Vehicle " ++ show(k) ++ ": " ++
    concat([ let { int: node =
                    if t = 1 then 0 else fix( if t = 2 then next[k,0]
                      else next[k, fix( if t = 3 then next[k,0]
                        else next[k, fix( if t = 4 then next[k, next[k,0]]
                          else next[k,0] endif ) ] endif ) ] endif ) }
             in ""  % not used (kept to satisfy MiniZinc scoping)
           | t in 1..0 ]) % will not execute
    ++ "\n"
  endif;

% Since MiniZinc has limited dynamic looping in output, we print arc list instead.
output [
  "Total distance = ", show(total_distance), "\n\n",
  "Used vehicles = ", show([fix(used[k]) | k in VEH]), "\n\n",
  "Arcs per vehicle (i -> next[k,i]):\n",
  concat([
    "Vehicle ", show(k), if fix(used[k])=1 then "" else " (unused)" endif, ":\n",
    concat([ "  ", show(i), " -> ", show(fix(next[k,i])), "\n"
           | i in NODES where (i=0 /\ fix(used[k])=1) \/ (i in CUST /\ fix(next[k,i]) != i) ]),
    "\n"
  | k in VEH ]),
  "Service start times (only served nodes shown):\n",
  concat([
    "Vehicle ", show(k), ":\n",
    concat([ "  node ", show(i), " start ", show(fix(start[k,i])), "\n"
           | i in NODES where (i=0 /\ fix(used[k])=1) \/ (i in CUST /\ fix(served[k,i])=1) ]),
    "\n"
  | k in VEH ])
];
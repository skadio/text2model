% VRP with Hard Time Windows (VRPHTW) - Embedded data
% Objective: minimize total traveled distance (Euclidean, scaled to integer)

include "globals.mzn";

%-----------------------------
% Sets / indices
%-----------------------------
int: Ncust = 20;
int: N = Ncust + 1;              % nodes: 0..20 (0 = depot)
set of int: Nodes = 0..Ncust;
set of int: Customers = 1..Ncust;

int: K = 5;                      % max trucks
set of int: Vehicles = 1..K;

int: Q = 200;                    % vehicle capacity
int: service = 90;               % fixed service duration for each customer (minutes)

%-----------------------------
% Data
%-----------------------------
array[Nodes] of int: x = [40, 45,45,42,42,42,40,40,38,38,35,35,25,22,22,20,20,18,15,15,30];
array[Nodes] of int: y = [50, 68,70,66,68,65,69,66,68,70,66,69,85,75,85,80,85,75,75,80,50];

array[Nodes] of int: demand = [0, 10,30,10,10,10,20,20,20,10,10,10,20,30,10,40,40,20,20,10,10];

array[Nodes] of int: tw_start = [0, 912,825,65,727,15,621,170,255,534,357,448,652,30,567,384,475,99,179,278,10];
array[Nodes] of int: tw_end   = [1236, 967,870,146,782,67,702,225,324,605,410,505,721,92,620,429,528,148,254,345,73];

%-----------------------------
% Distance / travel time
%-----------------------------
% Use Euclidean distance scaled by 100 and rounded to nearest int.
int: SCALE = 100;

function int: iSqrt(int: n) =
  let {
    int: x0 = if n <= 0 then 0 else n endif,
    int: x1 = (x0 + 1) div 2
  } in
  if n <= 0 then 0
  else
    let {
      int: a = x0,
      int: b = x1
    } in
    % Newton iterations (fixed count sufficient for these sizes)
    let {
      int: t1 = (b + n div b) div 2,
      int: t2 = (t1 + n div t1) div 2,
      int: t3 = (t2 + n div t2) div 2,
      int: t4 = (t3 + n div t3) div 2,
      int: t5 = (t4 + n div t4) div 2,
      int: t6 = (t5 + n div t5) div 2
    } in
      if t6 * t6 > n then t6 - 1 else t6 endif
  endif;

function int: dist_scaled(int: i, int: j) =
  let {
    int: dx = x[i] - x[j],
    int: dy = y[i] - y[j],
    int: d2 = dx*dx + dy*dy
  } in
    iSqrt(d2 * SCALE * SCALE); % floor of scaled euclidean

array[Nodes, Nodes] of int: dist = array2d(Nodes, Nodes,
  [ dist_scaled(i,j) | i in Nodes, j in Nodes ]
);

% Use distance as travel time as well (same scaled units).
array[Nodes, Nodes] of int: travel = dist;

% Service time per node (depot has 0 service time)
array[Nodes] of int: serv = [0] ++ [service | c in Customers];

% Time horizon (scaled consistently with minutes? Here minutes are raw, dist scaled by 100)
% To keep units consistent, treat travel times as "distance units", but time windows are in minutes.
% We therefore also scale minutes by SCALE so travel and service share same unit.
array[Nodes] of int: twS = [tw_start[i] * SCALE | i in Nodes];
array[Nodes] of int: twE = [tw_end[i]   * SCALE | i in Nodes];
array[Nodes] of int: servS = [serv[i] * SCALE | i in Nodes];

int: H = 2000 * SCALE;  % big horizon upper bound for time variables
int: M = H;             % big-M

%-----------------------------
% Decision variables
%-----------------------------
% xArc[v,i,j] = 1 if vehicle v goes directly from i to j
array[Vehicles, Nodes, Nodes] of var 0..1: xArc;

% start time of service at node i by vehicle v (only meaningful if visited)
array[Vehicles, Nodes] of var 0..H: t;

% vehicle used
array[Vehicles] of var 0..1: used;

%-----------------------------
% Constraints
%-----------------------------
% No self-loops
constraint forall(v in Vehicles, i in Nodes) ( xArc[v,i,i] = 0 );

% Each customer is visited exactly once (exactly one incoming across all vehicles)
constraint forall(c in Customers)(
  sum(v in Vehicles, i in Nodes)( xArc[v,i,c] ) = 1
);

% Flow conservation for each vehicle and customer:
% if vehicle enters customer then it leaves customer
constraint forall(v in Vehicles, c in Customers)(
  sum(i in Nodes)( xArc[v,i,c] ) = sum(j in Nodes)( xArc[v,c,j] )
);

% Depot degree per vehicle: if used then exactly one departure and one return
constraint forall(v in Vehicles)(
  sum(j in Customers)( xArc[v,0,j] ) = used[v] /\
  sum(i in Customers)( xArc[v,i,0] ) = used[v]
);

% Prevent arcs between depot and depot
constraint forall(v in Vehicles)( xArc[v,0,0] = 0 );

% Capacity per vehicle
constraint forall(v in Vehicles)(
  sum(c in Customers)( demand[c] * sum(i in Nodes)( xArc[v,i,c] ) ) <= Q
);

% Hard time windows and activation
% If vehicle v serves customer c then t[v,c] within its window.
constraint forall(v in Vehicles, c in Customers)(
  t[v,c] >= twS[c] - M * (1 - sum(i in Nodes)(xArc[v,i,c])) /\
  t[v,c] <= twE[c] + M * (1 - sum(i in Nodes)(xArc[v,i,c]))
);

% Depot time window (can start at 0; enforce if used)
constraint forall(v in Vehicles)(
  t[v,0] >= twS[0] - M * (1 - used[v]) /\
  t[v,0] <= twE[0] + M * (1 - used[v])
);

% Time propagation along used arcs:
% t[j] >= t[i] + service[i] + travel[i,j]   when arc i->j is chosen
constraint forall(v in Vehicles, i in Nodes, j in Nodes where i != j)(
  t[v,j] >= t[v,i] + servS[i] + travel[i,j] - M * (1 - xArc[v,i,j])
);

% If vehicle not used, it cannot visit customers (already implied by depot degree),
% but also keep times bounded (optional)
constraint forall(v in Vehicles, c in Customers)(
  t[v,c] <= H * sum(i in Nodes)(xArc[v,i,c])
);

% Symmetry breaking: enforce non-increasing usage (use earlier vehicles first)
constraint forall(v in 1..K-1)( used[v] >= used[v+1] );

%-----------------------------
% Objective
%-----------------------------
var int: total_distance = sum(v in Vehicles, i in Nodes, j in Nodes)( dist[i,j] * xArc[v,i,j] );

solve minimize total_distance;

%-----------------------------
% Output
%-----------------------------
output [
  "TotalDistanceScaled=" ++ show(total_distance) ++ "\n",
  "VehiclesUsed=" ++ show([used[v] | v in Vehicles]) ++ "\n",
  "Routes (arcs i->j):\n"
] ++
[
  "v=" ++ show(v) ++ " used=" ++ show(used[v]) ++ " arcs=" ++
  show([ (i,j) | i in Nodes, j in Nodes where fix(xArc[v,i,j]) = 1 ]) ++ "\n"
  | v in Vehicles
] ++
[
  "ServiceTimesScaled (t[v,i]):\n"
] ++
[
  "v=" ++ show(v) ++ " " ++
  show([ (i, t[v,i]) | i in Nodes where i=0 \/ exists(i0 in Nodes)(fix(xArc[v,i0,i])=1) ]) ++ "\n"
  | v in Vehicles
];
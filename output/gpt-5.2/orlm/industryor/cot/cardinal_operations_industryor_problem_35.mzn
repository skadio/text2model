% Parameters (with values embedded)
int: nCustomers = 20;
int: nNodes = nCustomers + 1;          % includes depot 0
set of int: N = 0..nCustomers;         % nodes
set of int: C = 1..nCustomers;         % customers

int: K = 5;                            % at most 5 trucks
set of int: V = 1..K;

int: Q = 200;                          % vehicle capacity

int: depotX = 40;
int: depotY = 50;
int: depotTWStart = 0;
int: depotTWEnd = 1236;

int: serviceTime = 90;

array[N] of int: x = [40, 45,45,42,42,42,40,40,38,38,35,35,25,22,22,20,20,18,15,15,30];
array[N] of int: y = [50, 68,70,66,68,65,69,66,68,70,66,69,85,75,85,80,85,75,75,80,50];

array[N] of int: demand = [0, 10,30,10,10,10,20,20,20,10,10,10,20,30,10,40,40,20,20,10,10];

array[N] of int: twStart =
  [depotTWStart,
   912, 825,  65, 727,  15, 621, 170, 255, 534,
   357, 448, 652,  30, 567, 384, 475,  99, 179, 278,  10];

array[N] of int: twEnd =
  [depotTWEnd,
   967, 870, 146, 782,  67, 702, 225, 324, 605,
   410, 505, 721,  92, 620, 429, 528, 148, 254, 345,  73];

% integer travel time / distance as Euclidean distance rounded up to nearest integer
array[N, N] of int: dist =
  array2d(N, N,
    [ if i==j then 0
      else
        let {
          int: dx = x[i]-x[j],
          int: dy = y[i]-y[j]
        } in
          ceil(sqrt(int2float(dx*dx + dy*dy)))
      endif
      | i in N, j in N
    ]);

% Big-M for time precedence (safe upper bound)
int: M = 20000;

% Variables
array[V, N, N] of var 0..1: arc;       % arc[v,i,j] = 1 if vehicle v travels i->j
array[V] of var 0..1: used;            % used[v]=1 if vehicle v is used
array[V, N] of var 0..depotTWEnd: t;   % service start time at node for vehicle v
array[V, N] of var 0..Q: load;         % load after servicing node (MTZ-style)

% Constraints
% Disallow self loops
constraint forall(v in V, i in N)(arc[v,i,i] = 0);

% Each customer is visited exactly once (one incoming and one outgoing across all vehicles)
constraint forall(c in C)(
  sum(v in V, i in N where i != c)(arc[v,i,c]) = 1
);
constraint forall(c in C)(
  sum(v in V, j in N where j != c)(arc[v,c,j]) = 1
);

% Vehicle flow conservation at customers (if a vehicle enters a customer, it leaves it)
constraint forall(v in V, c in C)(
  sum(i in N where i != c)(arc[v,i,c]) = sum(j in N where j != c)(arc[v,c,j])
);

% Each used vehicle leaves depot once and returns once; unused vehicles do neither
constraint forall(v in V)(
  sum(j in C)(arc[v,0,j]) = used[v]
);
constraint forall(v in V)(
  sum(i in C)(arc[v,i,0]) = used[v]
);

% Tighten: no arcs at all if vehicle unused (implied but strengthens)
constraint forall(v in V)(
  sum(i in N, j in N)(arc[v,i,j]) <= nNodes * used[v]
);

% Time windows (enforced if node is visited by vehicle)
% Depot time for each vehicle within depot window (always feasible with bounds)
constraint forall(v in V)(
  t[v,0] >= depotTWStart /\ t[v,0] <= depotTWEnd
);

constraint forall(v in V, c in C)(
  t[v,c] >= twStart[c] - M * (1 - sum(i in N where i != c)(arc[v,i,c])) /\
  t[v,c] <= twEnd[c]   + M * (1 - sum(i in N where i != c)(arc[v,i,c]))
);

% Time propagation along traveled arcs:
% if arc[v,i,j]=1 then t[v,j] >= t[v,i] + serviceTime(i) + travel(i,j)
% where serviceTime(0)=0, serviceTime(c)=90
constraint forall(v in V, i in N, j in N where i != j)(
  t[v,j] >= t[v,i] + (if i==0 then 0 else serviceTime endif) + dist[i,j] - M*(1 - arc[v,i,j])
);

% Capacity: MTZ-like load accumulation, only meaningful if visited by v
% Initialize depot load = 0
constraint forall(v in V)(load[v,0] = 0);

% Load bounds linked to visitation
constraint forall(v in V, c in C)(
  load[v,c] >= demand[c] * sum(i in N where i != c)(arc[v,i,c]) /\
  load[v,c] <= Q * sum(i in N where i != c)(arc[v,i,c])
);

% Load propagation: if arc[v,i,j]=1 then load[j] >= load[i] + demand[j]
% (for j=0 demand is 0; constrain only for j in C)
constraint forall(v in V, i in N, j in C where i != j)(
  load[v,j] >= load[v,i] + demand[j] - Q*(1 - arc[v,i,j])
);

% Also ensure route total demand <= Q by bounding loads (already) and via depot departure
constraint forall(v in V)(
  sum(c in C)(demand[c] * sum(i in N where i != c)(arc[v,i,c])) <= Q
);

% Objective
var int: totalDistance = sum(v in V, i in N, j in N)(dist[i,j] * arc[v,i,j]);

solve minimize totalDistance;

output [
  "Total distance = ", show(totalDistance), "\n",
  "Used vehicles = ", show(sum(v in V)(used[v])), "\n",
  "\nArcs (v: i->j):\n"
] ++
[
  if fix(arc[v,i,j]) == 1 then
    "v" ++ show(v) ++ ": " ++ show(i) ++ "->" ++ show(j) ++
    "  t(i)=" ++ show(t[v,i]) ++ " t(j)=" ++ show(t[v,j]) ++ "\n"
  else "" endif
  | v in V, i in N, j in N
];
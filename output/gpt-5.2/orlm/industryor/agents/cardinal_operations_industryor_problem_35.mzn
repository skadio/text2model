include "globals.mzn";

% Parameters
%======================
% Embedded instance data
%======================

int: nCustomers = 20;
int: nVehicles  = 5;

set of int: Customers = 1..nCustomers;
set of int: Vehicles  = 1..nVehicles;

% Node 0 is the depot, 1..nCustomers are customers
set of int: Nodes = 0..nCustomers;
int: depot = 0;

int: Q = 200;          % vehicle capacity
int: serviceDur = 90;  % fixed service duration at each customer (minutes)

% Coordinates (x,y) for depot and customers
array[Nodes] of int: x = [40,
  45,45,42,42,42,40,40,38,38,35,35,25,22,22,20,20,18,15,15,30
];
array[Nodes] of int: y = [50,
  68,70,66,68,65,69,66,68,70,66,69,85,75,85,80,85,75,75,80,50
];

% Demand (depot demand = 0)
array[Nodes] of int: demand = [0,
  10,30,10,10,10,20,20,20,10,10,10,20,30,10,40,40,20,20,10,10
];

% Hard time windows [twStart, twEnd] (minutes)
array[Nodes] of int: twStart = [0,
  912,825, 65,727, 15,621,170,255,534,357,448,652, 30,567,384,475, 99,179,278, 10
];
array[Nodes] of int: twEnd = [1236,
  967,870,146,782, 67,702,225,324,605,410,505,721, 92,620,429,528,148,254,345, 73
];

% Service time per node (depot = 0, customers = serviceDur)
array[Nodes] of int: serviceTime = [0] ++ [serviceDur | c in Customers];

% Travel distance and travel time (Euclidean distance rounded up to int)
array[Nodes, Nodes] of int: dist =
  array2d(Nodes, Nodes,
    [ if i = j then 0
      else
        let {
          int: dx = x[i] - x[j],
          int: dy = y[i] - y[j]
        } in
          ceil(sqrt(int2float(dx*dx + dy*dy)))
      endif
      | i in Nodes, j in Nodes
    ]);

% Assume travel time equals distance (minutes)
array[Nodes, Nodes] of int: travelTime = dist;

int: BIGM = 1000000;

% Variables
%======================

% arc[v,i,j] = 1 iff vehicle v travels directly from node i to node j
array[Vehicles, Nodes, Nodes] of var 0..1: arc;

% startTime[v,i] = service start time of vehicle v at node i (minutes)
array[Vehicles, Nodes] of var 0..1236: startTime;

% loadAfter[v,i] = load on vehicle v after servicing node i (units)
array[Vehicles, Nodes] of var 0..Q: loadAfter;

% Constraints
%======================

%-------------------------------
% Basic routing feasibility
%-------------------------------

% No self-loops
constraint forall(v in Vehicles, i in Nodes) (
  arc[v,i,i] = 0
);

% Each customer is visited exactly once (exactly one incoming arc across all vehicles)
constraint forall(c in Customers) (
  sum(v in Vehicles, i in Nodes)(arc[v,i,c]) = 1
);

% Flow conservation per vehicle at each customer:
% if a vehicle enters a customer, it must also leave it (and vice versa)
constraint forall(v in Vehicles, c in Customers) (
  sum(i in Nodes)(arc[v,i,c]) = sum(j in Nodes)(arc[v,c,j])
);

% Each vehicle starts from the depot at most once and returns to the depot at most once,
% and if it starts then it must also return (same count)
constraint forall(v in Vehicles) (
  sum(j in Customers)(arc[v,depot,j]) <= 1 /\
  sum(i in Customers)(arc[v,i,depot]) <= 1 /\
  sum(j in Customers)(arc[v,depot,j]) = sum(i in Customers)(arc[v,i,depot])
);

% Forbid direct depot->depot arc (redundant with no self-loops, kept explicit)
constraint forall(v in Vehicles) (
  arc[v,depot,depot] = 0
);

%-------------------------------
% Time window feasibility (hard)
%-------------------------------

% Anchor depot service start time to 0 for each vehicle (time reference)
constraint forall(v in Vehicles) (
  startTime[v,depot] = 0
);

% Enforce node time windows (hard) for all nodes.
% (Depot window included; customers must be served within their windows.)
constraint forall(v in Vehicles, i in Nodes) (
  startTime[v,i] >= twStart[i] /\
  startTime[v,i] <= twEnd[i]
);

% Time propagation along used arcs (waiting allowed implicitly by inequality).
% If arc[v,i,j]=1 then startTime[v,j] >= startTime[v,i] + serviceTime[i] + travelTime[i,j].
constraint forall(v in Vehicles, i in Nodes, j in Nodes where i != j) (
  startTime[v,j] >= startTime[v,i] + serviceTime[i] + travelTime[i,j]
                 - BIGM * (1 - arc[v,i,j])
);

%-------------------------------
% Capacity feasibility
%-------------------------------

% Load after depot is zero (vehicle starts empty at depot)
constraint forall(v in Vehicles) (
  loadAfter[v,depot] = 0
);

% Load propagation on arcs going to customers:
% if arc[v,i,j]=1 then loadAfter[v,j] = loadAfter[v,i] + demand[j]
constraint forall(v in Vehicles, i in Nodes, j in Customers where i != j) (
  loadAfter[v,j] >= loadAfter[v,i] + demand[j] - BIGM * (1 - arc[v,i,j]) /\
  loadAfter[v,j] <= loadAfter[v,i] + demand[j] + BIGM * (1 - arc[v,i,j])
);

% If vehicle v does not visit customer c, force loadAfter[v,c] to 0 (tightening),
% otherwise it is bounded by Q (already via variable domain and this constraint).
constraint forall(v in Vehicles, c in Customers) (
  loadAfter[v,c] <= Q * sum(i in Nodes)(arc[v,i,c])
);

% Objective
%======================
var int: totalDistance =
  sum(v in Vehicles, i in Nodes, j in Nodes)(dist[i,j] * arc[v,i,j]);

solve minimize totalDistance;
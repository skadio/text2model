% VRP with Hard Time Windows (VRPHTW) - embedded data
include "globals.mzn";

%------------------------
% Parameters / Data
%------------------------
int: nCustomers = 20;
set of int: NODES = 0..nCustomers;         % 0 = depot
set of int: CUSTOMERS = 1..nCustomers;

int: maxVehicles = 5;
set of int: VEHICLES = 1..maxVehicles;

int: capacity = 200;
int: depot = 0;

array[NODES] of int: x = [
  40,
  45, 45, 42, 42, 42, 40, 40, 38, 38, 35, 35, 25, 22, 22, 20, 20, 18, 15, 15, 30
];
array[NODES] of int: y = [
  50,
  68, 70, 66, 68, 65, 69, 66, 68, 70, 66, 69, 85, 75, 85, 80, 85, 75, 75, 80, 50
];

array[NODES] of int: demand = [
  0,
  10, 30, 10, 10, 10, 20, 20, 20, 10, 10, 10, 20, 30, 10, 40, 40, 20, 20, 10, 10
];

array[NODES] of int: twStart = [
  0,
  912, 825, 65, 727, 15, 621, 170, 255, 534, 357, 448, 652, 30, 567, 384, 475, 99, 179, 278, 10
];
array[NODES] of int: twEnd = [
  1236,
  967, 870, 146, 782, 67, 702, 225, 324, 605, 410, 505, 721, 92, 620, 429, 528, 148, 254, 345, 73
];

array[NODES] of int: service = [
  0,
  90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90
];

array[NODES, NODES] of int: dist =
  array2d(NODES, NODES,
    [ ceil(sqrt(int2float((x[i]-x[j])*(x[i]-x[j]) + (y[i]-y[j])*(y[i]-y[j]))))
      | i in NODES, j in NODES ]
  );

int: BIGM = 100000;

%------------------------
% Decision Variables
%------------------------
array[VEHICLES, NODES, NODES] of var 0..1: xArc;   % 1 if v uses arc i->j
array[VEHICLES, NODES] of var 0..1: visit;         % 1 if v visits node i
array[VEHICLES, NODES] of var 0..1236: startTime;  % start of service
array[VEHICLES, NODES] of var 0..capacity: loadAfter;
array[VEHICLES, CUSTOMERS] of var 0..nCustomers: order;

var 0..(maxVehicles * (nCustomers+1) * 1000): totalDistance;

%------------------------
% Constraints
%------------------------

% Each vehicle: exactly one outgoing arc per node (successor) and exactly one incoming arc per node (predecessor)
constraint
  forall(v in VEHICLES, i in NODES)(
    sum(j in NODES)(xArc[v,i,j]) = 1 /\
    sum(j in NODES)(xArc[v,j,i]) = 1
  );

% No self-loops except depot->depot (to represent unused vehicles)
constraint
  forall(v in VEHICLES, i in CUSTOMERS)( xArc[v,i,i] = 0 );

% Define visit for customers via inbound flow (0/1)
constraint
  forall(v in VEHICLES, c in CUSTOMERS)(
    visit[v,c] = sum(i in NODES)(xArc[v,i,c])
  );

% Fix depot visit to 1 for all vehicles (each vehicle has a cycle through depot; unused means 0->0)
constraint
  forall(v in VEHICLES)(
    visit[v,depot] = 1
  );

% Each customer served by exactly one vehicle
constraint
  forall(c in CUSTOMERS)(
    sum(v in VEHICLES)(visit[v,c]) = 1
  );

% Unused vehicle iff it goes depot->depot (and thus visits no customers)
constraint
  forall(v in VEHICLES)(
    (sum(c in CUSTOMERS)(visit[v,c]) = 0) <-> (xArc[v,depot,depot] = 1)
  );

% Capacity per vehicle
constraint
  forall(v in VEHICLES)(
    sum(c in CUSTOMERS)(demand[c] * visit[v,c]) <= capacity
  );

% Load initialization at depot
constraint
  forall(v in VEHICLES)(
    loadAfter[v,depot] = 0
  );

% Load propagation on arcs
constraint
  forall(v in VEHICLES, i in NODES, j in NODES where i != j)(
    loadAfter[v,j] >= loadAfter[v,i] + demand[j] - capacity * (1 - xArc[v,i,j]) /\
    loadAfter[v,j] <= loadAfter[v,i] + demand[j] + capacity * (1 - xArc[v,i,j])
  );

% If customer not visited by v, force its loadAfter to 0
constraint
  forall(v in VEHICLES, c in CUSTOMERS)(
    loadAfter[v,c] <= capacity * visit[v,c]
  );

% Time windows enforced only when visited
constraint
  forall(v in VEHICLES, i in NODES)(
    startTime[v,i] >= twStart[i] - BIGM * (1 - visit[v,i]) /\
    startTime[v,i] <= twEnd[i]   + BIGM * (1 - visit[v,i])
  );

% Time propagation along used arcs (waiting allowed)
constraint
  forall(v in VEHICLES, i in NODES, j in NODES where i != j)(
    startTime[v,j] >= startTime[v,i] + service[i] + dist[i,j] - BIGM * (1 - xArc[v,i,j])
  );

% MTZ order activation only if visited
constraint
  forall(v in VEHICLES, c in CUSTOMERS)(
    order[v,c] >= visit[v,c] /\
    order[v,c] <= nCustomers * visit[v,c]
  );

% MTZ subtour elimination among customers
constraint
  forall(v in VEHICLES, i in CUSTOMERS, j in CUSTOMERS where i != j)(
    order[v,i] + 1 <= order[v,j] + nCustomers * (1 - xArc[v,i,j])
  );

% Total distance
constraint
  totalDistance = sum(v in VEHICLES, i in NODES, j in NODES)(dist[i,j] * xArc[v,i,j]);

%------------------------
% Objective
% Note: user-specified "Objective Type" is maximization.
% To still reflect "minimize total distance", maximize negative distance.
%------------------------
solve maximize (-totalDistance);
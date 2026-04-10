% =======================
% Data (embedded)
% =======================
int: nContainersMax = 120 + 90 + 300 + 90 + 120; % safe upper bound: at most one unit per container
set of int: CONTAINERS = 1..nContainersMax;

set of int: GOODS = 1..5;
int: A = 1;
int: B = 2;
int: C = 3;
int: D = 4;
int: E = 5;

array[GOODS] of int: demand = [120, 90, 300, 90, 120];
array[GOODS] of float: weight = [0.5, 1.0, 0.4, 0.6, 0.65];

float: containerCap = 60.0;
float: containerMin = 18.0;

int: minDPerContainer = 12;

% =======================
% Decision variables
% =======================
array[CONTAINERS, GOODS] of var 0..max(demand): x;         % units of good g in container c
array[CONTAINERS] of var bool: used;                       % container is used iff it has any items
array[CONTAINERS] of var 0.0..containerCap: loadTons;      % tons loaded in container c
var 0..nContainersMax: numContainersUsed;

% =======================
% Constraints
% =======================
% Ship exactly the required demand of each good
constraint
  forall(g in GOODS) (
    sum(c in CONTAINERS)(x[c,g]) = demand[g]
  );

% Define container usage
constraint
  forall(c in CONTAINERS) (
    used[c] <-> (sum(g in GOODS)(x[c,g]) > 0)
  );

% Compute load in tons
constraint
  forall(c in CONTAINERS) (
    loadTons[c] = sum(g in GOODS)(weight[g] * int2float(x[c,g]))
  );

% Capacity and minimum load for used containers
constraint
  forall(c in CONTAINERS) (
    loadTons[c] <= containerCap
  );

constraint
  forall(c in CONTAINERS) (
    used[c] -> (loadTons[c] >= containerMin)
  );

% Packaging requirement: if A is loaded then at least 1 unit of C is loaded (per container)
constraint
  forall(c in CONTAINERS) (
    (x[c,A] > 0) -> (x[c,C] >= 1)
  );

% Each used container must load at least 12 units of D
constraint
  forall(c in CONTAINERS) (
    used[c] -> (x[c,D] >= minDPerContainer)
  );

% Count used containers (fixed syntax error)
constraint
  numContainersUsed = sum(c in CONTAINERS)(bool2int(used[c]));

% =======================
% Objective
% =======================
solve minimize numContainersUsed;
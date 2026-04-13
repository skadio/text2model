% Parameters
int: nToys = 4; % number of toy types

set of int: TOYS = 1..nToys; % index set for toys
int: ROBOT = 1;
int: CAR   = 2;
int: BLOCK = 3;
int: DOLL  = 4;

array[TOYS] of int: profit = [15, 8, 12, 5]; % profit per unit for each toy

int: plastic_available = 1200; % total plastic units available
array[TOYS] of int: plastic_req = [30, 10, 20, 15]; % plastic units required per unit

int: electronics_available = 800; % total electronic components available
array[TOYS] of int: electronics_req = [8, 5, 3, 2]; % electronics units required per unit

% Derived upper bounds (resource-based) for production quantities
array[TOYS] of int: ub_plastic =
  [plastic_available div plastic_req[t] | t in TOYS]; % per-toy upper bound from plastic
array[TOYS] of int: ub_electronics =
  [electronics_available div electronics_req[t] | t in TOYS]; % per-toy upper bound from electronics
array[TOYS] of int: ub =
  [min(ub_plastic[t], ub_electronics[t]) | t in TOYS]; % tightest resource upper bound per toy

% Variables
array[TOYS] of var 0..max(ub): x; % units to manufacture of each toy type (Robot, Car, Blocks, Doll)
array[TOYS] of var bool: make;    % whether a toy type is manufactured (x[t] > 0)

% Constraints

% Link production quantities to "make" indicator:
% - if make[t] = false then x[t] = 0
% - if make[t] = true  then x[t] >= 1
constraint
  forall(t in TOYS) (
    x[t] <= ub[t] * bool2int(make[t])
  );
constraint
  forall(t in TOYS) (
    x[t] >= bool2int(make[t])
  );

% Resource capacity: total plastic usage cannot exceed available
constraint
  sum(t in TOYS) (plastic_req[t] * x[t]) <= plastic_available;

% Resource capacity: total electronics usage cannot exceed available
constraint
  sum(t in TOYS) (electronics_req[t] * x[t]) <= electronics_available;

% Logical constraint: if robots are manufactured, dolls are not manufactured
constraint
  make[ROBOT] -> not make[DOLL];

% Logical constraint: if model cars are manufactured, building blocks are also manufactured
constraint
  make[CAR] -> make[BLOCK];

% Production relationship: dolls manufactured cannot exceed model cars manufactured
constraint
  x[DOLL] <= x[CAR];

% Objective
solve maximize sum(t in TOYS) (profit[t] * x[t]);
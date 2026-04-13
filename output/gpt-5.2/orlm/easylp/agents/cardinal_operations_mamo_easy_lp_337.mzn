% Parameters
int: nProducts = 4;                          % Number of products (X1..X4)
set of int: PRODUCTS = 1..nProducts;         % Product index set

array[PRODUCTS] of int: unitCost = [10, 12, 20, 15];   % Unit costs for X1..X4

% Production bounds
array[PRODUCTS] of int: lb = [0, 0, 0, 0];              % Lower bounds
array[PRODUCTS] of int: ub = [600, 500, 400, 300];      % Upper bounds

% Constraint RHS parameters
int: rawMatLimit = 1000;                     % X1 + X2 <= 1000
int: machineCapLimit = 1500;                 % 2*X1 + X3 <= 1500
int: demandMin = 1200;                       % 3*X2 + 2*X4 >= 1200
int: mixDiffMax = 500;                       % |X3 - X4| <= 500

% Variables
array[PRODUCTS] of var int: x;               % Production quantities (integers)

% Total cost (objective expression)
var int: totalCost = sum(p in PRODUCTS)(unitCost[p] * x[p]);

% Constraints
% Production quantity bounds
constraint
  forall(p in PRODUCTS) (
    lb[p] <= x[p] /\ x[p] <= ub[p]
  );

% Raw material limitation: X1 + X2 <= 1000
constraint
  x[1] + x[2] <= rawMatLimit;

% Machine capacity restriction: 2*X1 + X3 <= 1500
constraint
  2 * x[1] + x[3] <= machineCapLimit;

% Demand requirement: 3*X2 + 2*X4 >= 1200
constraint
  3 * x[2] + 2 * x[4] >= demandMin;

% Balanced product mix: |X3 - X4| <= 500
constraint
  abs(x[3] - x[4]) <= mixDiffMax;

% Objective
solve minimize totalCost;
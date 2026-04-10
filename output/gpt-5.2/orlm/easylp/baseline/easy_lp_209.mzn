% Hospital budget allocation (all data embedded)

int: BudgetMax = 1000;

% Decision variables: whole-dollar allocations
var 0..BudgetMax: X; % General Medicine
var 0..BudgetMax: Y; % Pediatrics
var 0..BudgetMax: Z; % Surgery

% Cost-effectiveness / cost per unit (as given)
int: cX = 50;
int: cY = 30;
int: cZ = 20;

constraint X + Y + Z <= BudgetMax;

% Department requirements
constraint X >= 2 * Y + 200;
constraint Z >= Y + 150;

% Objective: minimize total cost
var int: TotalCost = cX * X + cY * Y + cZ * Z;
solve minimize TotalCost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "TotalCost=", show(TotalCost), "\n"
];
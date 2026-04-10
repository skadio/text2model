% Budget allocation across three departments X, Y, Z
% Minimize total expenditure given minimum required allocations and total budget cap.

int: BUDGET_CAP = 1000;

int: minX = 300;
int: minY = 200;
int: minZ = 500;

int: costX = 10;
int: costY = 8;
int: costZ = 6;

% Decision variables (whole-number investments)
var minX..BUDGET_CAP: X;
var minY..BUDGET_CAP: Y;
var minZ..BUDGET_CAP: Z;

% Total budget cannot exceed cap
constraint X + Y + Z <= BUDGET_CAP;

% Objective: minimize total expenditure
var int: total_expenditure = costX*X + costY*Y + costZ*Z;

solve minimize total_expenditure;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Total expenditure (rounded) = ", show(total_expenditure), "\n"
];
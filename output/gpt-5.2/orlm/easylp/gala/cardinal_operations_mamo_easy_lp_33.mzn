% Investment allocation with minimum transaction cost
% Data embedded as required.

% Parameters
int: minX = 5000;
int: minY = 2000;
int: maxTotal = 10000;

% Interest rates expressed in basis points to keep integer arithmetic
int: rX_bp = 700;   % 7%  = 700 basis points
int: rY_bp = 800;   % 8%  = 800 basis points
int: minInterest = 700;  % dollars

% Transaction costs expressed in cents per dollar
int: cX_cents_per_dollar = 1;  % $0.01
int: cY_cents_per_dollar = 2;  % $0.02

% Decision variables (integers)
var minX..maxTotal: X;
var minY..maxTotal: Y;

% Constraints
constraint X + Y <= maxTotal;

% Interest constraint: 0.07*X + 0.08*Y >= 700
% Multiply by 10000: 700*X + 800*Y >= 700*10000
constraint rX_bp * X + rY_bp * Y >= minInterest * 10000;

% Objective: minimize total transaction cost in cents
var int: totalCostCents = cX_cents_per_dollar * X + cY_cents_per_dollar * Y;

solve minimize totalCostCents;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Min total transaction cost = ",
  show(totalCostCents div 100), ".",
  if (totalCostCents mod 100) < 10 then "0" else "" endif,
  show(totalCostCents mod 100),
  "\n"
];
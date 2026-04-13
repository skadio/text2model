include "globals.mzn";

% Data (embedded as requested)
int: BUDGET_MAX = 1000;
int: EFFECT_MIN = 800;
int: BALANCE_MAX = 300;

% Decision variables (integer investments)
var 0..BUDGET_MAX: X;  % purchasing
var 0..BUDGET_MAX: Y;  % manufacturing
var 0..BUDGET_MAX: Z;  % distribution

% Constraints
constraint X + Y + Z <= BUDGET_MAX;
constraint 3*X + 2*Y + 1*Z >= EFFECT_MIN;
constraint abs(X - Y) <= BALANCE_MAX;

% Objective: minimize total cost (2 per X, 3 per Y, 1 per Z)
var 0..(2*BUDGET_MAX + 3*BUDGET_MAX + 1*BUDGET_MAX): total_cost;
constraint total_cost = 2*X + 3*Y + Z;

solve minimize total_cost;

output [
  "X(purchasing) = ", show(X), "\n",
  "Y(manufacturing) = ", show(Y), "\n",
  "Z(distribution) = ", show(Z), "\n",
  "Minimum total cost = ", show(total_cost), "\n"
];
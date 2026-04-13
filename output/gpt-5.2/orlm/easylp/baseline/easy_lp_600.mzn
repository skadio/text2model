% Portfolio allocation minimization (all data embedded)

int: BUDGET = 100000;

int: X1_min = 10000; int: X1_max = 60000;
int: X2_min = 20000; int: X2_max = 80000;
int: X3_min = 15000; int: X3_max = 50000;
int: X4_min = 200;   int: X4_max = BUDGET; % no upper limit beyond budget

% Decision variables: dollar amounts (integers)
var X1_min..X1_max: x1;
var X2_min..X2_max: x2;
var X3_min..X3_max: x3;
var X4_min..X4_max: x4;

constraint x1 + x2 + x3 + x4 <= BUDGET;

% 0.60*x1 - 0.40*x2 >= 0  ->  3*x1 - 2*x2 >= 0
constraint 3 * x1 - 2 * x2 >= 0;

% x3 + x4 should not be less than (x1 + x2) by more than 30000
% -> (x1 + x2) - (x3 + x4) <= 30000
constraint (x1 + x2) - (x3 + x4) <= 30000;

% 0.70*x3 - 0.50*x4 <= 500  ->  7*x3 - 5*x4 <= 5000
constraint 7 * x3 - 5 * x4 <= 5000;

% Costs (scaled by 100 to keep integer objective)
% 0.05, 0.08, 0.12, 0.15 -> 5, 8, 12, 15 per dollar in cents
var 0..int_max: total_cost_cents =
    5 * x1 + 8 * x2 + 12 * x3 + 15 * x4;

solve minimize total_cost_cents;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "total_cost=$", show(total_cost_cents div 100), ".",
  if (total_cost_cents mod 100) < 10 then "0" else "" endif,
  show(total_cost_cents mod 100), "\n"
];
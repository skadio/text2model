% Hospital resource allocation between services X and Y
% Minimize total cost subject to constraints

int: max_total_resources = 50;
int: min_effectiveness = 30;
int: max_balance_diff = 10;

int: cost_x = 5;
int: cost_y = 10;

var 0..max_total_resources: X;
var 0..max_total_resources: Y;

constraint X + Y <= max_total_resources;

% Effectiveness: 2*X + Y >= 30
constraint 2*X + Y >= min_effectiveness;

% Balance: |X - 2*Y| <= 10
constraint abs(X - 2*Y) <= max_balance_diff;

var int: total_cost = cost_x * X + cost_y * Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost (USD) = ", show(total_cost), "\n"
];
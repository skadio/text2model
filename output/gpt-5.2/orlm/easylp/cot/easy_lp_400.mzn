% Parameters (with values embedded)
int: max_X1X2 = 200;
int: max_X3X4 = 150;

int: req_strength_12 = 1000;
int: req_strength_34_scaled = 1500; % scale by 2 to avoid 7.5: 2*(7.5*X3+5*X4) = 15*X3+10*X4

int: cost_X1 = 5000;
int: cost_X2 = 7000;
int: cost_X3 = 10000;
int: cost_X4 = 3000;

% Variables
var 0..max_X1X2: X1;
var 0..max_X1X2: X2;
var 0..max_X3X4: X3;
var 0..max_X3X4: X4;

var 0..intmax: total_cost;

% Constraints
constraint X1 + X2 <= max_X1X2;
constraint X3 + X4 <= max_X3X4;

constraint 5 * X1 + 10 * X2 >= req_strength_12;
constraint 15 * X3 + 10 * X4 >= req_strength_34_scaled;

constraint total_cost = cost_X1 * X1 + cost_X2 * X2 + cost_X3 * X3 + cost_X4 * X4;

% Objective
solve minimize total_cost;

output [
  "X1=", show(X1), "\n",
  "X2=", show(X2), "\n",
  "X3=", show(X3), "\n",
  "X4=", show(X4), "\n",
  "Minimum total cost ($)=", show(total_cost), "\n"
];
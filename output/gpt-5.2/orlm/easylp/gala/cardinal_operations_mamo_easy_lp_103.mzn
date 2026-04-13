% HR new hires allocation between departments X and Y
% All data embedded as required.

int: min_total_hires = 10;
int: max_weighted = 20;          % 2*X + Y <= 20

int: costX = 50;
int: costY = 30;

% Decision variables: whole numbers of hires
var 0..max_weighted: x;          % hires in department X
var 0..max_weighted: y;          % hires in department Y

% Constraints
constraint x + y >= min_total_hires;
constraint 2*x + y <= max_weighted;

% Objective: minimize onboarding cost
var int: total_cost = costX*x + costY*y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_onboarding_cost = $", show(total_cost), "\n"
];
% Parameters
int: n = 4;
set of int: CH = 1..n;

int: TV = 1;
int: Radio = 2;
int: Social = 3;
int: Outdoor = 4;

array[CH] of float: cost = [0.5, 0.6, 0.8, 1.2];
array[CH] of int: ub = [700, 600, 500, 400];

% Variables
array[CH] of var 0..700: x; % budgets (whole numbers)

% Constraints
constraint forall(c in CH) (x[c] <= ub[c]);

constraint x[TV] + x[Radio] >= 500;
constraint abs(x[Social] - x[Radio]) <= 200;
constraint x[Outdoor] >= x[TV] + 100;
constraint x[Social] + x[Outdoor] <= 800;

% Objective
var float: total_cost = sum(c in CH)(cost[c] * int2float(x[c]));
solve minimize total_cost;

output [
  "TV=", show(x[TV]), "\n",
  "Radio=", show(x[Radio]), "\n",
  "Social=", show(x[Social]), "\n",
  "Outdoor=", show(x[Outdoor]), "\n",
  "TotalCost=", show(total_cost), "\n",
  "TotalCostRounded2=", show(round(total_cost * 100.0) / 100.0), "\n"
];
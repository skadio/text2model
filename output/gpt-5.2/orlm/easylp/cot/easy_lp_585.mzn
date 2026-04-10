% Parameters (with values embedded)
int: n = 4;
set of int: CH = 1..n;

int: TV = 1;
int: Radio = 2;
int: Social = 3;
int: Outdoor = 4;

array[CH] of float: cost_per_unit = [0.5, 0.6, 0.8, 1.2];

array[CH] of int: max_alloc = [700, 600, 500, 400];

% Variables
array[CH] of var int: x;                 % budget allocations (whole numbers)
var int: total_cost_scaled;              % total cost scaled by 10 (to keep integers)
var float: total_cost;                   % total cost in thousands

% Constraints
constraint forall(c in CH) (x[c] >= 0 /\ x[c] <= max_alloc[c]);

% TV + Radio at least 500
constraint x[TV] + x[Radio] >= 500;

% |Social - Radio| <= 200
constraint abs(x[Social] - x[Radio]) <= 200;

% Outdoor >= TV + 100
constraint x[Outdoor] >= x[TV] + 100;

% Social + Outdoor <= 800
constraint x[Social] + x[Outdoor] <= 800;

% Cost scaling:
% costs are [0.5, 0.6, 0.8, 1.2] => scaled by 10 => [5,6,8,12]
constraint total_cost_scaled = 5*x[TV] + 6*x[Radio] + 8*x[Social] + 12*x[Outdoor];
constraint total_cost = int2float(total_cost_scaled) / 10.0;

% Objective
solve minimize total_cost_scaled;

output [
  "TV = ", show(x[TV]), "\n",
  "Radio = ", show(x[Radio]), "\n",
  "Social Media = ", show(x[Social]), "\n",
  "Outdoor = ", show(x[Outdoor]), "\n",
  "Minimum total cost (thousands) = ", show_float(2, total_cost), "\n"
];
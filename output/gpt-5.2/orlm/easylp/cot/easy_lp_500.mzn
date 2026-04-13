% Parameters (with values embedded)
int: max_total_properties = 1000;
int: min_weighted_properties = 2000; % 3*X + 2*Y >= 2000
int: max_difference = 300;           % |X - Y| <= 300

int: cost_residential_k = 200; % thousand dollars per residential property
int: cost_commercial_k  = 150; % thousand dollars per commercial property

% Variables
var 0..max_total_properties: X; % residential properties (integer)
var 0..max_total_properties: Y; % commercial properties (integer)

% Constraints
constraint X + Y <= max_total_properties;
constraint 3*X + 2*Y >= min_weighted_properties;
constraint abs(X - Y) <= max_difference;

% Objective
var 0..(cost_residential_k*max_total_properties + cost_commercial_k*max_total_properties): total_cost_k;
constraint total_cost_k = cost_residential_k * X + cost_commercial_k * Y;

solve minimize total_cost_k;

output [
  "X (residential) = ", show(X), "\n",
  "Y (commercial)  = ", show(Y), "\n",
  "Minimum total investment (thousand $) = ", show(total_cost_k), "\n"
];
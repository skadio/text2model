% Real estate investment allocation - minimize total cost

int: cost_res = 50000;
int: cost_com = 30000;
int: cost_ind = 70000;

int: max_total_properties = 10;

% Market availability bounds (not specified in the description),
% so we use the natural bounds implied by the total limit.
int: max_each = max_total_properties;

var 0..max_each: x; % residential
var 0..max_each: y; % commercial
var 0..max_each: z; % industrial

constraint x + y + z <= max_total_properties;

% Residential at least two more than commercial
constraint x >= y + 2;

% Difference between industrial and residential not exceed three
constraint abs(z - x) <= 3;

var int: total_cost = cost_res * x + cost_com * y + cost_ind * z;

solve minimize total_cost;

output [
  "Residential (x) = ", show(x), "\n",
  "Commercial  (y) = ", show(y), "\n",
  "Industrial  (z) = ", show(z), "\n",
  "Total properties = ", show(x + y + z), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];
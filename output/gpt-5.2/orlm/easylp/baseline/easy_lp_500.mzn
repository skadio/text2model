% Real estate investment optimization (all data embedded)

int: max_total_properties = 1000;
int: min_weighted_properties = 2000;
int: max_diff_properties = 300;

int: cost_residential_k = 200;  % thousand dollars per residential property
int: cost_commercial_k  = 150;  % thousand dollars per commercial property

var 0..max_total_properties: X; % residential properties
var 0..max_total_properties: Y; % commercial properties

constraint X + Y <= max_total_properties;
constraint 3*X + 2*Y >= min_weighted_properties;
constraint abs(X - Y) <= max_diff_properties;

var int: total_cost_k = cost_residential_k * X + cost_commercial_k * Y;

solve minimize total_cost_k;

output [
  "X(residential) = ", show(X), "\n",
  "Y(commercial)  = ", show(Y), "\n",
  "Minimum total investment (thousand dollars) = ", show(total_cost_k), "\n"
];
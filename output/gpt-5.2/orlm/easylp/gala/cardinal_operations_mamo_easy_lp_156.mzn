% Real estate developer: minimize construction cost
% Data embedded as per problem statement

int: max_total = 100;

int: x_min = 30;  % villas
int: x_max = 70;

int: y_min = 20;  % apartments
int: y_max = 80;

int: cost_x = 5000;
int: cost_y = 3000;

var x_min..x_max: X;
var y_min..y_max: Y;

constraint X + Y <= max_total;

var int: total_cost = cost_x * X + cost_y * Y;

solve minimize total_cost;

output [
  "X (villas) = ", show(X), "\n",
  "Y (apartments) = ", show(Y), "\n",
  "Total cost = ", show(total_cost), "\n"
];
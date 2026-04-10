% Real estate construction cost minimization

int: max_total = 100;
int: X_min = 30; int: X_max = 70;   % luxury villas
int: Y_min = 20; int: Y_max = 80;   % apartments

int: cost_villa = 5000;
int: cost_apartment = 3000;

var X_min..X_max: X;
var Y_min..Y_max: Y;

constraint X + Y <= max_total;

var int: total_cost = cost_villa * X + cost_apartment * Y;

solve minimize total_cost;

output [
  "X (villas) = ", show(X), "\n",
  "Y (apartments) = ", show(Y), "\n",
  "Total cost = $", show(total_cost), "\n"
];
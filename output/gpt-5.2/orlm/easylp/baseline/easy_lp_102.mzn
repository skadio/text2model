int: max_total_people = 100;
int: min_x = 20;
int: min_y = 10;

int: cost_x = 50;
int: cost_y = 30;

var min_x..max_total_people: x;
var min_y..max_total_people: y;

constraint x + y <= max_total_people;

var int: total_cost = cost_x * x + cost_y * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];
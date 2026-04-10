% Weekly scheduling for two teams X and Y (whole hours), minimize total cost.

int: max_total_hours = 24;

int: min_x = 4;
int: min_y = 6;

int: cost_x = 8;   % dollars per hour
int: cost_y = 10;  % dollars per hour

var min_x..max_total_hours: hours_x;
var min_y..max_total_hours: hours_y;

constraint hours_x + hours_y <= max_total_hours;

var int: total_cost = cost_x * hours_x + cost_y * hours_y;

solve minimize total_cost;

output [
  "hours_x = ", show(hours_x), "\n",
  "hours_y = ", show(hours_y), "\n",
  "min_total_cost_dollars = ", show(total_cost), "\n"
];
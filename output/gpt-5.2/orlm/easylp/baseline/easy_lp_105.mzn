int: max_total_hours = 15;
int: min_x = 5;
int: min_y = 3;

int: fatigue_x = 20;
int: fatigue_y = 30;

var min_x..max_total_hours: X;
var min_y..max_total_hours: Y;

constraint X + Y <= max_total_hours;

var int: total_fatigue = fatigue_x * X + fatigue_y * Y;

solve minimize total_fatigue;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "minimum_total_fatigue=", show(total_fatigue), "\n"
];
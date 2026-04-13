% Training hours allocation: minimize total fatigue
% All data embedded as required.

int: max_total_hours = 40;
int: min_x_hours = 15;
int: min_y_hours = 10;

int: fatigue_x = 2;
int: fatigue_y = 3;

var min_x_hours..max_total_hours: x;  % hours of workout X
var min_y_hours..max_total_hours: y;  % hours of workout Y

constraint x + y <= max_total_hours;

var int: total_fatigue = fatigue_x * x + fatigue_y * y;

solve minimize total_fatigue;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_fatigue = ", show(total_fatigue), "\n"
];
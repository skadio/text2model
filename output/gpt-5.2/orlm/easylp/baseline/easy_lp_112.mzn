int: max_hours = 40;
int: min_x = 15;
int: min_y = 10;

int: fatigue_x = 2;
int: fatigue_y = 3;

var 0..max_hours: X;
var 0..max_hours: Y;

constraint X + Y <= max_hours;
constraint X >= min_x;
constraint Y >= min_y;

var int: total_fatigue = fatigue_x * X + fatigue_y * Y;

solve minimize total_fatigue;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "minimum_total_fatigue=", show(total_fatigue), "\n"
];
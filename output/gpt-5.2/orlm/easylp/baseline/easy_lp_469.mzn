int: max_total_hours = 10;
int: min_effectiveness = 30;
int: max_diff = 2;

int: max_x = 6;
int: max_y = 8;

int: fatigue_x = 40;
int: fatigue_y = 60;

int: eff_x = 3;
int: eff_y = 4;

var 0..max_x: x;
var 0..max_y: y;

constraint x + y <= max_total_hours;
constraint eff_x * x + eff_y * y >= min_effectiveness;
constraint abs(x - y) <= max_diff;

var int: total_fatigue = fatigue_x * x + fatigue_y * y;

solve minimize total_fatigue;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "total_fatigue=", show(total_fatigue), "\n",
  "minimum_total_fatigue_rounded=", show(total_fatigue), "\n"
];
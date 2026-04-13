int: total_hours_max = 40;

int: x_max = 15;
int: y_max = 20;
int: z_max = 30;

int: fatigue_x = 2;
int: fatigue_y = 3;
int: fatigue_z = 1;

var 0..x_max: x;
var 0..y_max: y;
var 0..z_max: z;

constraint x + y + z <= total_hours_max;
constraint x >= y + 5;
constraint y >= z + 10;

var int: total_fatigue = fatigue_x * x + fatigue_y * y + fatigue_z * z;

solve minimize total_fatigue;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "z=", show(z), "\n",
  "total_fatigue=", show(total_fatigue), "\n"
];
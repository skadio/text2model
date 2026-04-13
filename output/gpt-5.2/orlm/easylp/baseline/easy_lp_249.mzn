% Task scheduling effort minimization (all data embedded)

int: max_total_tasks = 8;

int: effort_X = 4;
int: effort_Y = 2;
int: effort_Z = 3;

int: min_XY = 3;
int: max_YZ = 5;

var 0..max_total_tasks: X;
var 0..max_total_tasks: Y;
var 0..max_total_tasks: Z;

constraint X + Y + Z <= max_total_tasks;
constraint X + Y >= min_XY;
constraint Y + Z <= max_YZ;

var int: total_effort = effort_X * X + effort_Y * Y + effort_Z * Z;

solve minimize total_effort;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "total_effort=", show(total_effort), "\n"
];
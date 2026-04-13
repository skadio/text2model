int: timeX = 8;
int: timeY = 5;

int: maxTasks = 10;

int: effX = 2;
int: effY = 3;
int: minEff = 6;

var 0..maxTasks: x; % number of tasks of type X
var 0..maxTasks: y; % number of tasks of type Y

constraint x + y <= maxTasks;
constraint effX * x + effY * y >= minEff;

var int: total_time = timeX * x + timeY * y;

solve minimize total_time;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_time = ", show(total_time), " hours\n"
];
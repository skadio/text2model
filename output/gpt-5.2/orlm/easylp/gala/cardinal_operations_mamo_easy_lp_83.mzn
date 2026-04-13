% Task scheduling / integer optimization (all data embedded)

% Parameters from the description
int: timeX = 8;
int: timeY = 5;
int: maxTasks = 10;
int: minEffect = 6;

% Decision variables: number of tasks of each type (whole numbers)
var 0..maxTasks: x;  % number of X tasks
var 0..maxTasks: y;  % number of Y tasks

% Total time to minimize
var 0..(maxTasks * max(timeX, timeY)): totalTime = timeX * x + timeY * y;

% Constraints
constraint x + y <= maxTasks;
constraint 2 * x + 3 * y >= minEffect;

solve minimize totalTime;

output [
  "x (tasks X) = ", show(x), "\n",
  "y (tasks Y) = ", show(y), "\n",
  "totalTime = ", show(totalTime), " hours\n"
];
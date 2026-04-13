% Parameters (with values embedded)
int: n = 4;
set of int: G = 1..n;

array[G] of int: fatigue = [10, 15, 12, 20];

% Specific bounds are not provided in the description; use nonnegative integer hours
int: maxHours = 100; % safe upper bound for search

% Variables
array[G] of var 0..maxHours: x; % x[1]=x1, x[2]=x2, x[3]=x3, x[4]=x4 (integer hours)

% Constraints
constraint x[1] + x[2] <= 8;
constraint x[3] + x[4] <= 10;
constraint x[1] + x[3] >= 5;
constraint x[2] + x[4] >= 6;

% Objective
var int: total_fatigue = sum(i in G)(fatigue[i] * x[i]);

solve minimize total_fatigue;

output [
  "x1=", show(x[1]), " x2=", show(x[2]), " x3=", show(x[3]), " x4=", show(x[4]), "\n",
  "Minimum fatigue score (integer) = ", show(total_fatigue), "\n"
];
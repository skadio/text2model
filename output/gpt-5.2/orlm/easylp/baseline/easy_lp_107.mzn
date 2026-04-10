% Embedded data
int: max_total_hours = 50;
int: min_effectiveness = 20;
int: max_diff = 10;
int: costX = 5;
int: costY = 3;

% Decision variables (whole numbers of hours)
var 0..max_total_hours: x;  % hours of workout X
var 0..max_total_hours: y;  % hours of workout Y

% Constraints
constraint x + y <= max_total_hours;
constraint 2*x + y >= min_effectiveness;
constraint abs(x - 3*y) <= max_diff;

% Objective: minimize total fatigue
var int: fatigue = costX*x + costY*y;
solve minimize fatigue;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "minimum_fatigue=", show(fatigue), "\n"
];
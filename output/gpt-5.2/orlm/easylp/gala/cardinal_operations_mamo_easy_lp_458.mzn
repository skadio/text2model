% Resource allocation between two projects (integer hours)

% Data (embedded as requested)
int: costX = 5000;      % units per hour for Project X
int: costY = 3000;      % units per hour for Project Y

int: maxTotalHours = 20;
int: xMin = 0; int: xMax = 15;
int: yMin = 0; int: yMax = 10;

% Decision variables: hours allocated (whole numbers)
var xMin..xMax: x;      % hours for Project X
var yMin..yMax: y;      % hours for Project Y

% Constraints
constraint x + y <= maxTotalHours;
constraint 3 * x - 4 * y >= 5;
constraint 2 * x + y = 10;

% Objective: minimize total resource units required
var int: totalUnits = costX * x + costY * y;
solve minimize totalUnits;

output [
  "x_hours = ", show(x), "\n",
  "y_hours = ", show(y), "\n",
  "total_units = ", show(totalUnits), "\n"
];
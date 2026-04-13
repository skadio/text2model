% Resource allocation between two task types X and Y
% Embed all data directly (no .dzn)

int: maxHours = 20;
int: hoursX = 5;
int: hoursY = 3;

int: prodMin = 10;
int: prodX = 2;
int: prodY = 4;

int: costX = 50;
int: costY = 80;

% Decision variables: number of tasks (integers, nonnegative)
var 0..maxHours div min(hoursX, hoursY): X;
var 0..maxHours div min(hoursX, hoursY): Y;

% Constraints
constraint hoursX * X + hoursY * Y <= maxHours;
constraint prodX * X + prodY * Y >= prodMin;

% Objective: minimize total cost
var int: totalCost = costX * X + costY * Y;
solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "TotalCost = $", show(totalCost), "\n"
];
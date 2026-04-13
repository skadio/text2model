% Parameters
% Cost per activity for each project
float: costX = 0.5;
float: costY = 0.3;

% Resource/manpower constraint coefficients and RHS
int: aX = 2;           % coefficient for Project X in combined-activities constraint
int: aY = 3;           % coefficient for Project Y in combined-activities constraint
int: maxCombined = 5000;

% Minimum required difference between activities
int: minDiff = 100;

% Derived upper bounds for activities (nonnegative activities assumed)
int: maxX = maxCombined div aX;   % since aX*x <= maxCombined
int: maxY = maxCombined div aY;   % since aY*y <= maxCombined


% Variables
var 0..maxX: x;  % integer number of activities in Project X
var 0..maxY: y;  % integer number of activities in Project Y

% Objective variable (float since costs are fractional)
var float: totalCost;


% Constraints
% Combined resource/manpower limit: 2*X + 3*Y <= 5000
constraint
  aX * x + aY * y <= maxCombined;

% Minimum required difference in activities: X - Y >= 100
constraint
  x - y >= minDiff;

% Total cost definition (convert integers to float for fractional costs)
constraint
  totalCost = costX * int2float(x) + costY * int2float(y);


% Objective
solve minimize totalCost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "totalCost=", show(totalCost), "\n"
];
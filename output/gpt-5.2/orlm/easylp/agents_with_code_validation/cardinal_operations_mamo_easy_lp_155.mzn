% Parameters
int: costX = 300000;                 % Investment cost per property of type X (dollars)
int: costY = 200000;                 % Investment cost per property of type Y (dollars)
int: maxTotalProperties = 10;        % Zoning limit on total number of properties

% Variables
var 1..maxTotalProperties: numX;     % Number of properties of type X (at least 1)
var 1..maxTotalProperties: numY;     % Number of properties of type Y (at least 1)
var 0..(costX*maxTotalProperties + costY*maxTotalProperties): totalInvestment; % Total investment (dollars)

% Constraints
% Link total investment to the number of properties of each type
constraint
  totalInvestment = costX * numX + costY * numY;

% Zoning restriction: total number of properties cannot exceed the maximum allowed
constraint
  numX + numY <= maxTotalProperties;

% Portfolio balance requirement: number of X properties is at least five times number of Y properties
constraint
  numX >= 5 * numY;

% Objective
solve minimize totalInvestment;

output [
  "numX = ", show(numX), "\n",
  "numY = ", show(numY), "\n",
  "totalInvestment = $", show(totalInvestment), "\n"
];
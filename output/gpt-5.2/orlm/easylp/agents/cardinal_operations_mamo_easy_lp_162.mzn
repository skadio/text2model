% Parameters
int: costX = 200000;                  % Cost per property at location X (USD)
int: costY = 300000;                  % Cost per property at location Y (USD)
int: maxTotalProperties = 10;         % Maximum total number of properties allowed
int: minPropertiesEachLocation = 1;   % Minimum properties required in each location
int: xToYRatio = 3;                   % Requirement: X >= 3 * Y

% Variables
var 1..maxTotalProperties: numX;      % Number of properties purchased at location X
var 1..maxTotalProperties: numY;      % Number of properties purchased at location Y
var 0..(maxTotalProperties * max(costX, costY)): totalCost; % Total investment cost (USD)

% Constraints
% Total properties limit (budget/feasibility constraint)
constraint
  numX + numY <= maxTotalProperties;

% Minimum purchase in each location (legal requirement)
constraint
  numX >= minPropertiesEachLocation;
constraint
  numY >= minPropertiesEachLocation;

% Diversification / balance requirement: properties at X at least xToYRatio times Y
constraint
  numX >= xToYRatio * numY;

% Define total cost from decision variables
constraint
  totalCost = costX * numX + costY * numY;

% Objective
solve minimize totalCost;
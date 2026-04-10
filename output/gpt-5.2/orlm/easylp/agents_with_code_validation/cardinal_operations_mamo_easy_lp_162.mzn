% Parameters
int: costX = 200000;          % Cost per property at location X (USD)
int: costY = 300000;          % Cost per property at location Y (USD)
int: maxTotalProperties = 10; % Maximum total number of properties
int: minEachLocation = 1;     % Must buy at least one property in each location
int: ratioXY = 3;             % X must be at least 3 times Y

% Variables
var 0..maxTotalProperties: x;           % Number of properties bought at location X
var 0..maxTotalProperties: y;           % Number of properties bought at location Y
var 0..(costX*maxTotalProperties + costY*maxTotalProperties): totalCost; % Total cost (USD)

% Constraints
% Must buy at least one property in each location
constraint x >= minEachLocation;
constraint y >= minEachLocation;

% Total number of properties cannot exceed the maximum
constraint x + y <= maxTotalProperties;

% X must be at least ratioXY times Y
constraint x >= ratioXY * y;

% Define total investment cost
constraint totalCost = costX * x + costY * y;

% Objective
solve minimize totalCost;
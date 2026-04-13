% Parameters
int: costX = 300000;          % Investment cost for one property of type X ($)
int: costY = 200000;          % Investment cost for one property of type Y ($)
int: maxTotal = 10;           % Maximum total number of properties allowed
int: minX = 1;                % At least one X must be built
int: minY = 1;                % At least one Y must be built
int: ratioXY = 5;             % X must be at least 5 times Y

% Variables
var minX..maxTotal: numX;                     % Number of properties of type X (whole units)
var minY..maxTotal: numY;                     % Number of properties of type Y (whole units)
var 0..(costX*maxTotal + costY*maxTotal): totalInvestment;  % Total investment cost ($)

% Constraints
% Domain constraints: enforce whole units and minimum build requirements
constraint
  numX >= minX /\ numY >= minY;

% Zoning restriction: total number of properties cannot exceed the maximum
constraint
  numX + numY <= maxTotal;

% Portfolio balance constraint: X must be at least ratioXY times Y
constraint
  numX >= ratioXY * numY;

% Total investment definition: link decision variables to total cost
constraint
  totalInvestment = costX * numX + costY * numY;

% Objective
solve minimize totalInvestment;
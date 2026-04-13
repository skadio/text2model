% Parameters
% Cost per vehicle on each route (embedded data; no .dzn expected)
int: costX = 2;
int: costY = 3;
int: costZ = 4;

% Operational limits/requirements (embedded data)
int: maxXY = 100;   % X + Y <= 100
int: maxYZ = 150;   % Y + Z <= 150
int: minXZ = 80;    % X + Z >= 80


% Variables
% Number of vehicles on each route (nonnegative integers)
var 0..maxXY: x;                      % vehicles on route X
var 0..max(maxXY, maxYZ): y;          % vehicles on route Y
var 0..maxYZ: z;                      % vehicles on route Z

% Total operating cost (integer units)
var int: totalCost;


% Constraints
% Capacity / operational limit: combined vehicles on routes X and Y
constraint x + y <= maxXY;

% Capacity / operational limit: combined vehicles on routes Y and Z
constraint y + z <= maxYZ;

% Coverage requirement: combined vehicles on routes X and Z must meet minimum
constraint x + z >= minXZ;

% Total cost definition (linking decision variables to totalCost)
constraint totalCost = costX * x + costY * y + costZ * z;


% Objective
solve minimize totalCost;
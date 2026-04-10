% Parameters
% Cost per vehicle on each route (embedded from problem statement)
int: costX = 2;
int: costY = 3;
int: costZ = 4;

% Operational limits / requirements (embedded from problem statement)
int: maxXY = 100;   % X + Y <= 100
int: maxYZ = 150;   % Y + Z <= 150
int: minXZ = 80;    % X + Z >= 80

% Variables
% Number of vehicles on each route (non-negative integers with safe upper bounds)
var 0..maxXY: x;                       % route X
var 0..max(maxYZ, minXZ): z;           % route Z (safe bound)
var 0..max(maxXY, maxYZ): y;           % route Y (safe bound)

% Total operational cost (integer)
var 0..(costX*maxXY + costY*max(maxXY,maxYZ) + costZ*max(maxYZ,minXZ)): total_cost;

% Constraints
%--- Route capacity / operational limit constraints ---
constraint x + y <= maxXY;
constraint y + z <= maxYZ;
constraint x + z >= minXZ;

%--- Cost aggregation constraint ---
constraint total_cost = costX * x + costY * y + costZ * z;

% Objective
solve minimize total_cost;
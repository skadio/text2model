% Parameters
% Hiring costs per employee (in dollars)
int: costX = 5000;
int: costY = 6000;
int: costZ = 7000;

% Global hiring limit
int: maxTotalHires = 100;

% Department capacity limits
int: maxX = 50;
int: maxY = 30;
int: maxZ = 20;

% Staffing ratio/offset requirements
int: offsetX_over_2Y = 10;  % X >= 2*Y + 10
int: offsetY_over_Z  = 5;   % Y >= Z + 5


% Variables
var 0..maxX: hiresX;  % number of new hires in department X
var 0..maxY: hiresY;  % number of new hires in department Y
var 0..maxZ: hiresZ;  % number of new hires in department Z

% Total hiring cost (bounded by max capacities)
var 0..(costX*maxX + costY*maxY + costZ*maxZ): totalCost;


% Constraints
% Total hires must respect the global hiring limit
constraint hiresX + hiresY + hiresZ <= maxTotalHires;

% Staffing ratio / offset requirements between departments
constraint hiresX >= 2 * hiresY + offsetX_over_2Y;
constraint hiresY >= hiresZ + offsetY_over_Z;

% Define total hiring cost from departmental hires and per-hire costs
constraint totalCost = costX * hiresX + costY * hiresY + costZ * hiresZ;


% Objective
solve minimize totalCost;
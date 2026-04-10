% Parameters
% Unit costs for allocating one unit of resource to each department
int: costX = 5;
int: costY = 3;
int: costZ = 2;

% Capacity/requirement limits
int: maxXY = 1000;   % X + Y <= 1000
int: maxYZ = 800;    % Y + Z <= 800
int: minXZ = 500;    % X + Z >= 500

% Simple upper bounds derived from constraints (used to bound variables explicitly)
int: ubX = maxXY;                 % since X <= X+Y <= 1000
int: ubZ = maxYZ;                 % since Z <= Y+Z <= 800
int: ubY = min(maxXY, maxYZ);     % since Y <= 1000 and Y <= 800

% Variables
var 0..ubX: x;  % integer units allocated to department X
var 0..ubY: y;  % integer units allocated to department Y
var 0..ubZ: z;  % integer units allocated to department Z
var 0..(costX*ubX + costY*ubY + costZ*ubZ): total_cost; % total cost (objective-related)

% Constraints
% Link total_cost to decision variables (cost accounting)
constraint
  total_cost = costX * x + costY * y + costZ * z;

% Resource capacity: combined allocation for departments X and Y cannot exceed maxXY
constraint
  x + y <= maxXY;

% Resource capacity: combined allocation for departments Y and Z cannot exceed maxYZ
constraint
  y + z <= maxYZ;

% Balance requirement: combined allocation for departments X and Z must be at least minXZ
constraint
  x + z >= minXZ;

% Objective
solve minimize total_cost;
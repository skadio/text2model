% Parameters
% Unit returns/costs for each project
int: costX = 10;
int: costY = 15;
int: costZ = 20;

% Investment bounds (inclusive)
int: minX = 0;
int: maxX = 2000;
int: minY = 0;
int: maxY = 1500;
int: minZ = 0;
int: maxZ = 2500;

% Combined investment constraints
int: maxXY = 5000;   % X + Y <= 5000
int: minYZ = 3000;   % Y + Z >= 3000
int: maxXZ = 4000;   % X + Z <= 4000


% Variables
% Integer investments in each project
var minX..maxX: x;   % investment in project X
var minY..maxY: y;   % investment in project Y
var minZ..maxZ: z;   % investment in project Z

% Total cost to minimize (safe upper bound from max investments)
var 0..(costX*maxX + costY*maxY + costZ*maxZ): total_cost;


% Constraints
% --- Link total cost to investments (linear cost calculation) ---
constraint
  total_cost = costX * x + costY * y + costZ * z;

% --- Combined investment (budget/feasibility) constraints ---
% X + Y cannot exceed maxXY
constraint
  x + y <= maxXY;

% Y + Z must be at least minYZ
constraint
  y + z >= minYZ;

% X + Z cannot exceed maxXZ
constraint
  x + z <= maxXZ;


% Objective
solve minimize total_cost;
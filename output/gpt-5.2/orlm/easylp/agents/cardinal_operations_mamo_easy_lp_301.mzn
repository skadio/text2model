% Parameters
% Unit costs per investment unit for each project
int: costX = 5;
int: costY = 3;
int: costZ = 2;

% Constraint right-hand-sides
int: maxXY = 20;      % X + Y <= 20
int: min2YplusZ = 10; % 2*Y + Z >= 10
int: maxXZ = 15;      % X + Z <= 15

% Simple derived bounds (non-negative integers, plus loose upper bounds from constraints)
int: ubX = min(maxXY, maxXZ); % X <= 15
int: ubY = maxXY;             % Y <= 20
int: ubZ = maxXZ;             % Z <= 15

% Variables
var 0..ubX: x; % integer investment in project X
var 0..ubY: y; % integer investment in project Y
var 0..ubZ: z; % integer investment in project Z

% Total cost to minimize
var 0..(costX*ubX + costY*ubY + costZ*ubZ): total_cost;

% Constraints
% Resource/budget constraints between projects
constraint x + y <= maxXY;               % X + Y cannot exceed maxXY
constraint 2 * y + z >= min2YplusZ;      % 2*Y + Z must be at least min2YplusZ
constraint x + z <= maxXZ;               % X + Z cannot exceed maxXZ

% Total cost definition (linking decision variables to cost)
constraint total_cost = costX * x + costY * y + costZ * z;

% Objective
solve minimize total_cost;

output [
  "x=", show(x), " y=", show(y), " z=", show(z), "\n",
  "total_cost=", show(total_cost), "\n"
];
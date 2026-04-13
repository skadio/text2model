% Parameters
int: costX = 10;                    % Operating cost per vehicle on route X
int: costY = 15;                    % Operating cost per vehicle on route Y
int: costZ = 20;                    % Operating cost per vehicle on route Z

int: maxXY = 1000;                  % Upper bound on vehicles on routes X+Y
int: maxYZ = 800;                   % Upper bound on vehicles on routes Y+Z
int: minXZ = 500;                   % Lower bound on vehicles on routes X+Z

int: capX = 700;                    % Capacity limit on route X
int: capY = 600;                    % Capacity limit on route Y
int: capZ = 400;                    % Capacity limit on route Z

% Variables
var 0..capX: x;                     % Vehicles on route X
var 0..capY: y;                     % Vehicles on route Y
var 0..capZ: z;                     % Vehicles on route Z

% Upper bound is a safe worst-case (all routes at capacity)
var 0..(costX*capX + costY*capY + costZ*capZ): total_cost;

% Constraints
% --- Route-combination traffic/restriction constraints ---
constraint x + y <= maxXY;          % Combined vehicles on routes X and Y cannot exceed maxXY
constraint y + z <= maxYZ;          % Combined vehicles on routes Y and Z cannot exceed maxYZ
constraint x + z >= minXZ;          % Service level: combined vehicles on routes X and Z must be at least minXZ

% --- Total operating cost definition (linking constraint) ---
constraint total_cost = costX*x + costY*y + costZ*z;

% Objective
solve minimize total_cost;

output [
  "x=", show(x), " y=", show(y), " z=", show(z), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];
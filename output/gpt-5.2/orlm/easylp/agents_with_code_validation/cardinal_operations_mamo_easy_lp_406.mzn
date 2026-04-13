% Parameters
% Cost per unit allocated to each vessel
int: costX = 10;
int: costY = 15;
int: costZ = 20;
int: costW = 25;

% Capacity limits (upper bounds on combined allocations)
int: capXY = 500;   % X + Y <= 500
int: capZW = 700;   % Z + W <= 700

% Minimum shipment requirements (lower bounds on combined allocations)
int: minXZ = 200;   % X + Z >= 200
int: minYW = 300;   % Y + W >= 300


% Variables
% Integer cargo allocation to each vessel (non-negative)
var 0..capXY: x;    % allocation to vessel X
var 0..capXY: y;    % allocation to vessel Y
var 0..capZW: z;    % allocation to vessel Z
var 0..capZW: w;    % allocation to vessel W

% Total cost (bounded using max possible allocations under caps)
var 0..(costX*capXY + costY*capXY + costZ*capZW + costW*capZW): total_cost;


% Constraints
% Total cost definition (linear expression of allocations)
constraint
  total_cost = costX * x + costY * y + costZ * z + costW * w;

% Capacity constraints for vessel pairs
constraint
  x + y <= capXY;     % X + Y cannot exceed 500

constraint
  z + w <= capZW;     % Z + W cannot exceed 700

% Minimum shipment / balance constraints across vessel types
constraint
  x + z >= minXZ;     % X + Z must be at least 200

constraint
  y + w >= minYW;     % Y + W must be at least 300


% Objective
solve minimize total_cost;
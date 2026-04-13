% Parameters
int: max_total_resources = 100;              % Total resources available (units)

int: cost_x = 500;                           % Cost per unit for area X ($/unit)
int: cost_y = 300;                           % Cost per unit for area Y ($/unit)
int: cost_z = 700;                           % Cost per unit for area Z ($/unit)

int: min_x = 20;                             % Minimum resources for X (units)
int: min_y = 30;                             % Minimum resources for Y (units)
int: min_z = 10;                             % Minimum resources for Z (units)

% Variables
var min_x..max_total_resources: x;           % Resources allocated to X (integer units)
var min_y..max_total_resources: y;           % Resources allocated to Y (integer units)
var min_z..max_total_resources: z;           % Resources allocated to Z (integer units)

% Upper bound uses the worst-case of assigning all 100 units to each area (safe bound)
var 0..(cost_x*max_total_resources
       + cost_y*max_total_resources
       + cost_z*max_total_resources): total_cost; % Total cost ($)

% Constraints
% --- Total resource availability ---
constraint
  x + y + z <= max_total_resources;

% --- Minimum resource requirements (redundant with variable domains but kept for clarity) ---
constraint
  x >= min_x /\ y >= min_y /\ z >= min_z;

% --- Inter-area allocation relationships ---
% "X should be at least twice as much as that subtracted from the allocation for Y"
% Interpreted as: x >= 2 * (y - x)
constraint
  x >= 2 * (y - x);

% "Y should be at least twice as much as that subtracted from the allocation for Z"
% Interpreted as: y >= 2 * (z - y)
constraint
  y >= 2 * (z - y);

% --- Total cost definition ---
constraint
  total_cost = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_cost;
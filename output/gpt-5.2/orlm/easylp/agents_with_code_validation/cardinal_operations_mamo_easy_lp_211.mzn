% Parameters
int: total_resources = 100;          % Total available resource units
int: min_extra_x = 10;               % X must be at least this much more than half of Y
int: max_yz = 60;                    % Upper bound on Y + Z
int: cost_x = 5;                     % Cost per unit allocated to X
int: cost_y = 3;                     % Cost per unit allocated to Y
int: cost_z = 7;                     % Cost per unit allocated to Z

% Variables
var 0..total_resources: x;           % Units allocated to department X
var 0..total_resources: y;           % Units allocated to department Y
var 0..total_resources: z;           % Units allocated to department Z
var 0..(cost_x*total_resources + cost_y*total_resources + cost_z*total_resources): total_cost; % Total cost

% Constraints
% --- Resource capacity constraint: total allocation cannot exceed available resources
constraint x + y + z <= total_resources;

% --- Department X requirement: X must be at least 10 more than half of Y (integer half via div)
constraint x >= min_extra_x + (y div 2);

% --- Combined limit for Y and Z: infrastructure/staff cap
constraint y + z <= max_yz;

% --- Total cost definition: linear cost aggregation
constraint total_cost = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_cost;
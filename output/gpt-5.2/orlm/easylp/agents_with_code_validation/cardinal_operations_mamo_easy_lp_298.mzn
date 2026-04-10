% Parameters
% Budget / capacity limits
int: max_total_resources = 100;           % X + Y + Z <= 100
int: min_env_score = 50;                 % 2*Y + Z >= 50
int: max_xz_resources = 80;              % X + Z <= 80

% Initiative costs per unit resource
int: cost_x = 2;                         % cost per unit for X
int: cost_y = 3;                         % cost per unit for Y
int: cost_z = 1;                         % cost per unit for Z

% Variable upper bounds (derived from limits)
int: ub_x = min(max_total_resources, max_xz_resources);  % X <= 80
int: ub_y = max_total_resources;                          % Y <= 100
int: ub_z = min(max_total_resources, max_xz_resources);   % Z <= 80


% Variables
var 0..ub_x: x;                          % resources allocated to initiative X
var 0..ub_y: y;                          % resources allocated to initiative Y
var 0..ub_z: z;                          % resources allocated to initiative Z

% Total cost variable (bounded for tighter search)
var 0..(cost_x*ub_x + cost_y*ub_y + cost_z*ub_z): total_cost;


% Constraints
% --- Resource capacity / budget limit ---
constraint x + y + z <= max_total_resources;

% --- Environmental score requirement ---
constraint 2 * y + z >= min_env_score;

% --- Logistical limit on X and Z combined ---
constraint x + z <= max_xz_resources;

% --- Total cost definition ---
constraint total_cost = cost_x * x + cost_y * y + cost_z * z;


% Objective
solve minimize total_cost;
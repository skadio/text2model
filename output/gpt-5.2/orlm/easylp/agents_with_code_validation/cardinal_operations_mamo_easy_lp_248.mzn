% Parameters
int: max_total_shifts = 24;          % Total shifts across all worker types per day
int: cost_x = 8;                    % Cost per shift for worker type X
int: cost_y = 6;                    % Cost per shift for worker type Y
int: cost_z = 10;                   % Cost per shift for worker type Z

int: max_x = 12;                    % Maximum shifts type X can cover per day
int: max_y = 8;                     % Maximum shifts type Y can cover per day
int: max_z = 6;                     % Maximum shifts type Z can cover per day

int: min_x_over_y = 2;              % X must be at least this many more shifts than Y
int: max_diff_yz = 4;               % |Y - Z| must not exceed this value

% Variables
var 0..max_x: shifts_x;             % Number of shifts assigned to worker type X
var 0..max_y: shifts_y;             % Number of shifts assigned to worker type Y
var 0..max_z: shifts_z;             % Number of shifts assigned to worker type Z

% Total daily cost (tight upper bound from per-type maxima)
var 0..(cost_x*max_x + cost_y*max_y + cost_z*max_z): total_cost;

% Constraints
% --- Total shift capacity across all worker types ---
constraint
  shifts_x + shifts_y + shifts_z <= max_total_shifts;

% --- Skill requirement: X must cover at least min_x_over_y more shifts than Y ---
constraint
  shifts_x >= shifts_y + min_x_over_y;

% --- Balance requirement: difference between Y and Z cannot exceed max_diff_yz ---
constraint
  abs(shifts_y - shifts_z) <= max_diff_yz;

% --- Total cost definition (linking total_cost to decision variables) ---
constraint
  total_cost = cost_x * shifts_x + cost_y * shifts_y + cost_z * shifts_z;

% Objective
solve minimize total_cost;
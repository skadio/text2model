% Parameters
int: max_total_shifts = 24;          % Maximum total shifts per day across all worker types
int: cost_X = 8;                     % Cost per shift for worker type X
int: cost_Y = 6;                     % Cost per shift for worker type Y
int: cost_Z = 10;                    % Cost per shift for worker type Z

int: max_X = 12;                     % Maximum shifts worker type X can cover
int: max_Y = 8;                      % Maximum shifts worker type Y can cover
int: max_Z = 6;                      % Maximum shifts worker type Z can cover

int: min_diff_XY = 2;                % X must be at least 2 more than Y
int: max_abs_diff_YZ = 4;            % |Y - Z| must not exceed 4


% Variables
var 0..max_X: shifts_X;              % Number of shifts assigned to worker type X
var 0..max_Y: shifts_Y;              % Number of shifts assigned to worker type Y
var 0..max_Z: shifts_Z;              % Number of shifts assigned to worker type Z

% Upper bound for total cost based on maximum possible shifts per type
var 0..(cost_X*max_X + cost_Y*max_Y + cost_Z*max_Z): total_cost;


% Constraints
%--- Total number of shifts cannot exceed the daily operational limit ---
constraint
  shifts_X + shifts_Y + shifts_Z <= max_total_shifts;

%--- Per-worker-type capacity limits (already enforced by variable domains, repeated for clarity) ---
constraint shifts_X <= max_X;
constraint shifts_Y <= max_Y;
constraint shifts_Z <= max_Z;

%--- Skill requirement: X must cover at least min_diff_XY more shifts than Y ---
constraint
  shifts_X >= shifts_Y + min_diff_XY;

%--- Workforce balance: absolute difference between Y and Z cannot exceed max_abs_diff_YZ ---
constraint
  abs(shifts_Y - shifts_Z) <= max_abs_diff_YZ;

%--- Define total cost from assigned shifts and per-shift costs ---
constraint
  total_cost = cost_X * shifts_X + cost_Y * shifts_Y + cost_Z * shifts_Z;


% Objective
solve minimize total_cost;

% Output
output [
  "shifts_X = ", show(shifts_X), "\n",
  "shifts_Y = ", show(shifts_Y), "\n",
  "shifts_Z = ", show(shifts_Z), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];
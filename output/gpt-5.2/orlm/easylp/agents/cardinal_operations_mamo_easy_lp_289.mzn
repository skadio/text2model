% Parameters
int: effort_x = 5;                 % Effort score per hour for activity X (academic lessons)
int: effort_y = 4;                 % Effort score per hour for activity Y (extracurricular activities)
int: effort_z = 3;                 % Effort score per hour for activity Z (student counseling)

int: max_xy = 100;                 % Upper bound on combined hours of X and Y
int: min_xz = 50;                  % Lower bound on combined hours of X and Z
int: max_diff_yz = 20;             % Maximum allowed absolute difference between Y and Z

% Upper bounds for variables (safe, derived from constraints and non-negativity)
int: ub_x = max_xy;                % Since X <= X+Y <= 100
int: ub_y = max_xy;                % Since Y <= X+Y <= 100
int: ub_z = max_xy + max_diff_yz;  % Since Z <= Y + 20 and Y <= 100 => Z <= 120

% Variables
var 0..ub_x: hours_x;              % Whole hours allocated to activity X
var 0..ub_y: hours_y;              % Whole hours allocated to activity Y
var 0..ub_z: hours_z;              % Whole hours allocated to activity Z

var 0..(effort_x*ub_x + effort_y*ub_y + effort_z*ub_z): total_effort; % Total effort score

% Constraints

% Total effort definition (linear combination of hours and per-hour effort scores)
constraint total_effort =
  effort_x * hours_x + effort_y * hours_y + effort_z * hours_z;

% Scheduling limitation: combined hours of X and Y cannot exceed the maximum
constraint hours_x + hours_y <= max_xy;

% Balanced program requirement: combined hours of X and Z must be at least the minimum
constraint hours_x + hours_z >= min_xz;

% Balance between extracurriculars and counseling: |Y - Z| must not exceed max_diff_yz
constraint abs(hours_y - hours_z) <= max_diff_yz;

% Objective
solve minimize total_effort;
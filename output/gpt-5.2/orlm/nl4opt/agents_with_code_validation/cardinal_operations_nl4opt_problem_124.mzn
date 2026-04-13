% Parameters
int: gems_required = 800;                 % Total gems that must be processed per day
int: water_available = 700;               % Total water units available per day

int: hi_gems_per_drill = 50;              % Gems processed per high intensity drill per day
int: hi_water_per_drill = 50;             % Water used per high intensity drill per day

int: lo_gems_per_drill = 30;              % Gems processed per low intensity drill per day
int: lo_water_per_drill = 20;             % Water used per low intensity drill per day

int: min_low_drills = 10;                 % At least this many low intensity drills must be used


% Variables
var 0..gems_required div hi_gems_per_drill + 1: n_hi;  % Number of high intensity drills
var 0..gems_required div lo_gems_per_drill + 1: n_lo;  % Number of low intensity drills

% Upper bound: enough drills if all were the slower drill, plus slack
var 0..(gems_required div min(hi_gems_per_drill, lo_gems_per_drill) + 10): n_total; % Total drills


% Constraints
% Total drills definition
constraint
  n_total = n_hi + n_lo;

% Gems processing requirement (must process at least the required number of gems)
constraint
  hi_gems_per_drill * n_hi + lo_gems_per_drill * n_lo >= gems_required;

% Water availability limit (cannot exceed available water)
constraint
  hi_water_per_drill * n_hi + lo_water_per_drill * n_lo <= water_available;

% Noise pollution rule: at most 40% of the drills can be high intensity
% n_hi / n_total <= 0.4  ->  5*n_hi <= 2*n_total  (integer-safe form)
constraint
  5 * n_hi <= 2 * n_total;

% Minimum number of low intensity drills
constraint
  n_lo >= min_low_drills;


% Objective
solve minimize n_total;
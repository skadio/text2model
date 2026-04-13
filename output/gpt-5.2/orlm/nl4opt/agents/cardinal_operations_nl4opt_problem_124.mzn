% Parameters
int: hi_capacity = 50;          % Gems processed per high intensity drill per day
int: hi_water = 50;             % Water units required per high intensity drill per day
int: lo_capacity = 30;          % Gems processed per low intensity drill per day
int: lo_water = 20;             % Water units required per low intensity drill per day

int: demand_gems = 800;         % Gems that must be processed per day
int: water_available = 700;     % Water units available per day

float: max_hi_fraction = 0.40;  % At most 40% of drills can be high intensity
int: min_lo_drills = 10;        % At least 10 low intensity drills

% Variables
var 0..ceil(demand_gems / hi_capacity): hi_drills;                 % Number of high intensity drills used
var min_lo_drills..ceil(demand_gems / lo_capacity): lo_drills;     % Number of low intensity drills used
var 0..(ceil(demand_gems / hi_capacity) + ceil(demand_gems / lo_capacity)): total_drills; % Total drills used

% Constraints

% Total drills definition
constraint
  total_drills = hi_drills + lo_drills;

% Meet daily gem processing demand (capacity constraint)
constraint
  hi_drills * hi_capacity + lo_drills * lo_capacity >= demand_gems;

% Do not exceed available water (resource constraint)
constraint
  hi_drills * hi_water + lo_drills * lo_water <= water_available;

% Noise pollution limit: at most max_hi_fraction of all drills are high intensity
% Avoid float arithmetic by cross-multiplying:
constraint
  100 * hi_drills <= round(100.0 * max_hi_fraction) * total_drills;

% Minimum number of low intensity drills is already enforced by variable domain,
% but we restate it explicitly for clarity/robustness.
constraint
  lo_drills >= min_lo_drills;

% Objective
solve minimize total_drills;
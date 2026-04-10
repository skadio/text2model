% Parameters
% Delivery rates (drops per minute)
int: drops_motion = 50;
int: drops_manual = 75;

% Energy consumption (kWh per minute)
int: kwh_motion = 30;
int: kwh_manual = 20;

% Policy/requirements
float: max_manual_fraction = 0.40;   % at most 40% of all machines can be manual
int: min_motion = 3;                 % at least 3 motion-activated machines
int: min_total_drops = 1000;         % required delivery capacity
int: max_total_kwh = 500;            % energy limit

% Variables
var 0..1000: n_motion;  % number of motion-activated machines
var 0..1000: n_manual;  % number of manual machines
var 0..2000: n_total;   % total machines (for objective convenience)

% Constraints
% --- Total machines definition ---
constraint
  n_total = n_motion + n_manual;

% --- Minimum delivery capacity (drops per minute) ---
constraint
  drops_motion * n_motion + drops_manual * n_manual >= min_total_drops;

% --- Maximum energy consumption (kWh per minute) ---
constraint
  kwh_motion * n_motion + kwh_manual * n_manual <= max_total_kwh;

% --- Hygiene/policy: at most 40% manual machines ---
% n_manual / n_total <= 0.40  <=>  5 * n_manual <= 2 * n_total
% (uses integer arithmetic to avoid float coercion)
constraint
  5 * n_manual <= 2 * n_total;

% --- Minimum number of motion-activated machines ---
constraint
  n_motion >= min_motion;

% Objective
solve minimize n_total;
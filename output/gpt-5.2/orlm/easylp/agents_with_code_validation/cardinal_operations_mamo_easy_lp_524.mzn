% Parameters
% Cost per hour for each staff group (embedded from problem statement)
int: cost_nurse = 500;
int: cost_doctor = 300;
int: cost_admin = 700;

% Weekly hour limits/requirements (embedded from problem statement)
int: max_total_hours = 100;      % X + Y + Z <= 100
int: min_diff_XY = 10;           % |X - Y| >= 10
int: max_diff_ZX = 20;           % |Z - X| <= 20
int: min_extra_Z_over_Y = 30;    % Z - Y >= 30


% Variables
var 0..max_total_hours: X; % weekly nurse hours
var 0..max_total_hours: Y; % weekly doctor hours
var 0..max_total_hours: Z; % weekly administrative hours

var int: total_cost;       % total staffing cost in dollars


% Constraints
% Total weekly hours budget restriction
constraint
  X + Y + Z <= max_total_hours;

% Balance between nurses and doctors: difference must be at least min_diff_XY
constraint
  abs(X - Y) >= min_diff_XY;

% Admin vs nurses: difference must not exceed max_diff_ZX
constraint
  abs(Z - X) <= max_diff_ZX;

% Admin must exceed doctors by at least min_extra_Z_over_Y hours
constraint
  Z - Y >= min_extra_Z_over_Y;

% Define total staffing cost from hourly costs and assigned hours
constraint
  total_cost = cost_nurse * X + cost_doctor * Y + cost_admin * Z;


% Objective
solve minimize total_cost;
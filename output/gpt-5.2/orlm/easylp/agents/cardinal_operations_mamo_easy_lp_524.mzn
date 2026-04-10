% Parameters
% Cost per hour for each staff group
int: cost_nurse = 500;
int: cost_doctor = 300;
int: cost_admin = 700;

% Weekly total hours limit
int: max_total_hours = 100;

% Constraint thresholds (in hours)
int: min_diff_nurse_doctor = 10;     % |X - Y| >= 10
int: max_diff_admin_nurse = 20;      % |Z - X| <= 20
int: min_admin_over_doctor = 30;     % Z - Y >= 30

% Practical bounds for weekly hours (whole numbers)
int: min_hours = 0;
int: max_hours = max_total_hours;


% Variables
var min_hours..max_hours: X; % Weekly nurse hours
var min_hours..max_hours: Y; % Weekly doctor hours
var min_hours..max_hours: Z; % Weekly administrative personnel hours

var int: total_cost; % Total staffing cost in dollars


% Constraints
% Total hours budget constraint
constraint X + Y + Z <= max_total_hours;

% Minimum absolute difference between nurse and doctor hours: |X - Y| >= 10
constraint abs(X - Y) >= min_diff_nurse_doctor;

% Maximum absolute difference between admin and nurse hours: |Z - X| <= 20
constraint abs(Z - X) <= max_diff_admin_nurse;

% Admin hours must exceed doctor hours by at least 30: Z - Y >= 30
constraint Z - Y >= min_admin_over_doctor;

% Define total staffing cost from hours and per-hour costs
constraint total_cost = cost_nurse * X + cost_doctor * Y + cost_admin * Z;


% Objective
solve minimize total_cost;
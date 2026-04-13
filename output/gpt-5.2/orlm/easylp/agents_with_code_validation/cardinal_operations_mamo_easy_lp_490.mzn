% Parameters
% Resource/logistical constraint coefficients and limit
int: coeff_log_X = 10;         % coefficient for X in logistical constraint
int: coeff_log_Y = 20;         % coefficient for Y in logistical constraint
int: log_limit  = 3000;        % logistical resource limit

% Strategic strength constraint coefficients and minimum requirement
int: coeff_str_X = 3;          % coefficient for X in strength constraint
int: coeff_str_Y = 5;          % coefficient for Y in strength constraint
int: str_min     = 500;        % minimum required combined strength

% Balance constraint
int: max_diff = 1000;          % maximum allowed absolute difference between X and Y

% Costs (support points in dollars per unit)
int: cost_X = 10000;           % dollars per unit of X
int: cost_Y = 20000;           % dollars per unit of Y

% Useful upper bounds derived from constraints (for bounded variable domains)
int: ub_X = log_limit div coeff_log_X;  % maximum possible X from logistical constraint
int: ub_Y = log_limit div coeff_log_Y;  % maximum possible Y from logistical constraint


% Variables
var 0..ub_X: units_X;          % number of units of type X (integer, nonnegative)
var 0..ub_Y: units_Y;          % number of units of type Y (integer, nonnegative)

% Total support cost in dollars (bounded for a finite search domain)
var 0..(cost_X * ub_X + cost_Y * ub_Y): total_cost;


% Constraints
% --- Logistical resource capacity: 10*X + 20*Y <= 3000
constraint
  coeff_log_X * units_X + coeff_log_Y * units_Y <= log_limit;

% --- Strategic minimum strength: 3*X + 5*Y >= 500
constraint
  coeff_str_X * units_X + coeff_str_Y * units_Y >= str_min;

% --- Balance between allocations: |X - Y| <= 1000
constraint
  abs(units_X - units_Y) <= max_diff;

% --- Define total cost in dollars: total_cost = 10000*X + 20000*Y
constraint
  total_cost = cost_X * units_X + cost_Y * units_Y;


% Objective
solve minimize total_cost;
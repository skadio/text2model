% Parameters
% Unit investment costs (in whole dollars)
int: cost_residential = 200000;
int: cost_commercial  = 300000;
int: cost_industrial  = 500000;
int: cost_retail      = 700000;

% Upper bounds on number of units (all investments are whole units)
int: ub_residential = 20;
int: ub_commercial  = 30;
int: ub_industrial  = 15;
int: ub_retail      = 10;

% Constraint limits / RHS values
int: max_res_plus_com = 50;        % x1 + x2 <= 50
int: min_2ind_plus_ret = 60;       % 2*x3 + x4 >= 60
int: max_3res_plus_45com = 100;    % 3*x1 + 4.5*x2 <= 100
int: max_6ind_minus_05ret = 80;    % 6*x3 - 0.5*x4 <= 80


% Variables
var 0..ub_residential: x1; % residential units
var 0..ub_commercial:  x2; % commercial units
var 0..ub_industrial:  x3; % industrial units
var 0..ub_retail:      x4; % retail units

% Total cost (in dollars)
var int: total_cost;


% Constraints
% Link total_cost to the linear investment cost expression
constraint
  total_cost =
    cost_residential * x1 +
    cost_commercial  * x2 +
    cost_industrial  * x3 +
    cost_retail      * x4;

% Zoning / budget limitation: residential + commercial cannot exceed limit
constraint
  x1 + x2 <= max_res_plus_com;

% Minimum activity requirement: 2*industrial + retail must be at least limit
constraint
  2 * x3 + x4 >= min_2ind_plus_ret;

% Capacity constraint with fractional coefficient: 3*x1 + 4.5*x2 <= limit
% Multiply by 2 to avoid non-integer coefficients: 6*x1 + 9*x2 <= 2*limit
constraint
  6 * x1 + 9 * x2 <= 2 * max_3res_plus_45com;

% Capacity constraint with fractional coefficient: 6*x3 - 0.5*x4 <= limit
% Multiply by 2 to avoid non-integer coefficients: 12*x3 - x4 <= 2*limit
constraint
  12 * x3 - x4 <= 2 * max_6ind_minus_05ret;


% Objective
solve minimize total_cost;
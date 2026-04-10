% Parameters
% Unit costs (in thousands per unit of resource)
float: cost_X1 = 0.5;
float: cost_X2 = 0.3;
float: cost_X3 = 0.4;
float: cost_X4 = 0.6;

% Constraint limits
int: limit_X1_X2 = 5000;     % X1 + X2 <= 5000
int: min_gap_X2_X3 = 1000;   % X2 >= X3 + 1000
int: limit_X3_2X4 = 3000;    % X3 + 2*X4 <= 3000
int: min_gap_X4_X1 = 100;    % X4 >= X1 + 100

% Variable bounds
int: X1_lb = 0;
int: X1_ub = 2000;

int: X2_lb = 0;
int: X2_ub = 1500;

int: X3_lb = 500;
int: X3_ub = 1500;

int: X4_lb = 500;
int: X4_ub = 2000;


% Variables
var X1_lb..X1_ub: X1;  % integer resource allocation for project X1
var X2_lb..X2_ub: X2;  % integer resource allocation for project X2
var X3_lb..X3_ub: X3;  % integer resource allocation for project X3
var X4_lb..X4_ub: X4;  % integer resource allocation for project X4

% Total cost (in thousands)
var float: total_cost;

% Total cost rounded to 1 decimal place (in thousands)
var int: total_cost_times10;   % total_cost * 10, for 1-decimal rounding
var float: total_cost_rounded; % rounded total cost to 1 decimal place


% Constraints

% --- Core resource allocation constraints (problem requirements) ---
constraint
  % Combined allocation for X1 and X2 must not exceed the given limit
  X1 + X2 <= limit_X1_X2;

constraint
  % X2 must be at least min_gap_X2_X3 more than X3
  X2 >= X3 + min_gap_X2_X3;

constraint
  % X3 plus twice X4 must not exceed the given limit
  X3 + 2 * X4 <= limit_X3_2X4;

constraint
  % X4 must be at least min_gap_X4_X1 more than X1
  X4 >= X1 + min_gap_X4_X1;

% --- Total cost definition (in thousands) ---
constraint
  % Compute total_cost from unit costs and integer allocations
  total_cost = cost_X1 * int2float(X1)
             + cost_X2 * int2float(X2)
             + cost_X3 * int2float(X3)
             + cost_X4 * int2float(X4);

% --- Rounding total cost to 1 decimal place (in thousands) ---
constraint
  % Link scaled cost to integer variable (avoid float-int coercion issues)
  total_cost_times10 = round(10.0 * total_cost);

constraint
  % Rounded cost back to float with 1 decimal place representation
  total_cost_rounded = int2float(total_cost_times10) / 10.0;


% Objective
solve minimize total_cost;
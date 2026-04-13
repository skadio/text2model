% Parameters
% Coefficients and bounds from the problem statement (embedded directly)
int: output_coef_x = 4;          % coefficient of x in minimum output constraint
int: output_coef_y = 6;          % coefficient of y in minimum output constraint
int: min_output = 12;            % minimum required output

int: consump_coef_x = 3;         % coefficient of x in maximum consumption constraint
int: consump_coef_y = 5;         % coefficient of y in maximum consumption constraint
int: max_consumption = 15;       % maximum allowed consumption

int: cost_x = 7;                 % cost per unit of project X
int: cost_y = 10;                % cost per unit of project Y

% Useful derived upper bounds (nonnegative integer resources)
int: x_ub = max_consumption div consump_coef_x;  % floor(15/3) = 5
int: y_ub = max_consumption div consump_coef_y;  % floor(15/5) = 3

% Variables
var 0..x_ub: x;                  % integer units allocated to project X
var 0..y_ub: y;                  % integer units allocated to project Y

var 0..(cost_x * x_ub + cost_y * y_ub): total_cost;  % total cost to minimize

% Constraints
% --- Minimum output requirement ---
constraint
  output_coef_x * x + output_coef_y * y >= min_output;

% --- Maximum consumption limit ---
constraint
  consump_coef_x * x + consump_coef_y * y <= max_consumption;

% --- Define total cost from decision variables ---
constraint
  total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;
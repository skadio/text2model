% Parameters
int: min_output = 12;          % Minimum required output score
int: max_consumption = 15;     % Maximum allowed resource consumption

int: output_coef_x = 4;        % Output coefficient for project X
int: output_coef_y = 6;        % Output coefficient for project Y

int: cons_coef_x = 3;          % Consumption coefficient for project X
int: cons_coef_y = 5;          % Consumption coefficient for project Y

int: cost_x = 7;               % Cost per unit of project X
int: cost_y = 10;              % Cost per unit of project Y

% Upper bounds derived from max_consumption (since x,y >= 0)
int: x_ub = max_consumption div cons_coef_x; % floor(15/3)=5
int: y_ub = max_consumption div cons_coef_y; % floor(15/5)=3

% Variables
var 0..x_ub: x;                % Whole units allocated to Project X
var 0..y_ub: y;                % Whole units allocated to Project Y

var 0..(cost_x*x_ub + cost_y*y_ub): total_cost; % Total cost to minimize

% Constraints
% Total cost definition (linking variable to decision variables)
constraint
  total_cost = cost_x * x + cost_y * y;

% Minimum output requirement: 4x + 6y >= 12
constraint
  output_coef_x * x + output_coef_y * y >= min_output;

% Maximum consumption limit: 3x + 5y <= 15
constraint
  cons_coef_x * x + cons_coef_y * y <= max_consumption;

% Objective
solve minimize total_cost;
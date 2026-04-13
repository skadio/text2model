% Parameters
% Resource requirement and capacity thresholds
int: min_req_2x3y = 200;        % Minimum required: 2*X + 3*Y >= 200
int: max_cap_4x1y = 300;        % Maximum allowed: 4*X + 1*Y <= 300

% Upper bounds on allocations
int: max_x = 100;               % X <= 100
int: max_y = 80;                % Y <= 80

% Unit costs (dollars per unit)
int: cost_x = 500;              % Cost per unit of X
int: cost_y = 600;              % Cost per unit of Y


% Variables
var 0..max_x: x_units;          % Integer units allocated to project X
var 0..max_y: y_units;          % Integer units allocated to project Y
var 0..(cost_x*max_x + cost_y*max_y): total_cost;  % Total cost in dollars


% Constraints
% Project requirement: combined allocation for 2*X + 3*Y must meet minimum threshold
constraint 2 * x_units + 3 * y_units >= min_req_2x3y;

% Capacity/balance limit: combined allocation for 4*X + Y must not exceed maximum threshold
constraint 4 * x_units + y_units <= max_cap_4x1y;

% Dominance constraint: allocation to project X must be at least that of project Y
constraint x_units >= y_units;

% Define total cost consistently with unit costs and allocations
constraint total_cost = cost_x * x_units + cost_y * y_units;


% Objective
solve minimize total_cost;
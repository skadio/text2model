% Parameters
int: total_resource_limit = 1000;          % Maximum total resources available (X + Y + Z)
int: min_portfolio_requirement = 500;      % Minimum requirement for 2*X + Y
int: xz_technical_limit = 600;             % Maximum allowed for X + 2*Z

int: cost_x = 6;                           % Cost per unit allocated to Project X
int: cost_y = 3;                           % Cost per unit allocated to Project Y
int: cost_z = 5;                           % Cost per unit allocated to Project Z

% Variables
var 0..total_resource_limit: x;            % Integer units allocated to Project X
var 0..total_resource_limit: y;            % Integer units allocated to Project Y
var 0..total_resource_limit: z;            % Integer units allocated to Project Z

var 0..(cost_x*total_resource_limit + cost_y*total_resource_limit + cost_z*total_resource_limit): total_cost;
                                           % Total cost of allocations

% Constraints
% Link total_cost to the decision variables (linear cost definition)
constraint total_cost = cost_x * x + cost_y * y + cost_z * z;

% Total resource budget constraint (X + Y + Z cannot exceed limit)
constraint x + y + z <= total_resource_limit;

% Balanced portfolio requirement (2*X + Y must be at least the minimum)
constraint 2 * x + y >= min_portfolio_requirement;

% Technical/logistical limitation (X + 2*Z cannot exceed limit)
constraint x + 2 * z <= xz_technical_limit;

% Objective
solve minimize total_cost;
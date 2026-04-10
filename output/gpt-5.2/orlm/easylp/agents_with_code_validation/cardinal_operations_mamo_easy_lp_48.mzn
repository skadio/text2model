% Parameters
int: min_service_requirement = 10;        % Minimum required service level: X + 3*Y >= 10
int: budget_limit = 30;                   % Budget feasibility: 2*X + Y <= 30
int: cost_x = 4;                          % Cost per unit for department X
int: cost_y = 5;                          % Cost per unit for department Y

% Variables
var 0..budget_limit: x_units;             % Whole units allocated to department X
var 0..budget_limit: y_units;             % Whole units allocated to department Y
var 0..(cost_x*budget_limit + cost_y*budget_limit): total_cost; % Total cost (bounded)

% Constraints
% --- Service level constraint: ensure essential services are maintained ---
constraint x_units + 3 * y_units >= min_service_requirement;

% --- Budget feasibility constraint: allocations must respect the budget limit ---
constraint 2 * x_units + y_units <= budget_limit;

% --- Total cost definition: link total_cost to decision variables ---
constraint total_cost = cost_x * x_units + cost_y * y_units;

% Objective
solve minimize total_cost;
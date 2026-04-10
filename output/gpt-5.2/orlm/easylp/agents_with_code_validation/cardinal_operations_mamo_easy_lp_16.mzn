% Parameters
int: min_total_allocation = 50;        % Minimum total resources allocated to X and Y
int: max_balanced_expr = 30;           % Upper bound for (2*X - Y)
int: cost_per_unit_x = 4;              % Cost per unit allocated to project X
int: cost_per_unit_y = 3;              % Cost per unit allocated to project Y

% Safe upper bounds for decision variables (to keep search space finite)
int: ub_x = 80;                        % Derived safe upper bound for X
int: ub_y = 130;                       % Derived safe upper bound for Y

% Variables
var 0..ub_x: x;                        % Integer units allocated to project X
var 0..ub_y: y;                        % Integer units allocated to project Y
var 0..(cost_per_unit_x * ub_x + cost_per_unit_y * ub_y): total_cost; % Total cost (bounded)

% Constraints
% --- Minimum total allocation requirement ---
constraint x + y >= min_total_allocation;

% --- Portfolio balance constraint (limits 2*X - Y) ---
constraint 2 * x - y <= max_balanced_expr;

% --- Total cost definition (linking variable to decision variables) ---
constraint total_cost = cost_per_unit_x * x + cost_per_unit_y * y;

% Objective
solve minimize total_cost;
% Parameters
int: total_budget = 1000;            % Max total allocation units across all projects

int: min_x = 200;                    % Minimum viable allocation for project X
int: min_y = 150;                    % Minimum viable allocation for project Y
int: min_z = 100;                    % Minimum viable allocation for project Z

int: max_excess_xy = 50;             % X cannot exceed Y by more than this amount
int: min_diff_yz = 20;               % Y must be at least this much more than Z

int: cost_x = 300;                   % Cost per unit for X (dollars)
int: cost_y = 500;                   % Cost per unit for Y (dollars)
int: cost_z = 200;                   % Cost per unit for Z (dollars)

% Variables
% Resource allocations (nonnegative integers; bounds added for better propagation)
var min_x..total_budget: x;          % Allocation to project X (units)
var min_y..total_budget: y;          % Allocation to project Y (units)
var min_z..total_budget: z;          % Allocation to project Z (units)

% Total cost (bounded for better propagation)
var 0..(cost_x + cost_y + cost_z) * total_budget: total_cost;

% Constraints
% --- Total allocation must not exceed overall budget (in units) ---
constraint x + y + z <= total_budget;

% --- Relative allocation constraints between projects ---
% X cannot exceed Y by more than max_excess_xy units: x - y <= max_excess_xy
constraint x <= y + max_excess_xy;

% Y must be at least min_diff_yz units more than Z: y - z >= min_diff_yz
constraint y >= z + min_diff_yz;

% --- Total cost definition (linear; allocations are integral by var int) ---
constraint total_cost = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_cost;
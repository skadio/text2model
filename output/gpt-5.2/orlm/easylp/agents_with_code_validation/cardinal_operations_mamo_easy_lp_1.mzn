% Parameters
int: max_total_budget = 2000;        % Maximum combined budget for channels X and Y (dollars)
int: cost_per_unit_X  = 50;          % Cost per unit of effectiveness for channel X (dollars)
int: cost_per_unit_Y  = 100;         % Cost per unit of effectiveness for channel Y (dollars)
int: min_diff_points  = 500;         % Minimum required difference in points: 3*X - 2*Y >= 500

% Variables
var 0..max_total_budget: x_budget;   % Integer budget allocated to channel X (dollars)
var 0..max_total_budget: y_budget;   % Integer budget allocated to channel Y (dollars)
var 0..(max_total_budget * max(cost_per_unit_X, cost_per_unit_Y)): total_cost;
                                     % Total cost to minimize (dollars)

% Constraints
% --- Total budget limit across both channels ---
constraint
  x_budget + y_budget <= max_total_budget;

% --- Reach/frequency (points difference) requirement ---
% Effort constraint: 3*X - 2*Y must be at least the required minimum difference.
constraint
  3 * x_budget - 2 * y_budget >= min_diff_points;

% --- Define total cost from allocated budgets and unit costs ---
constraint
  total_cost = cost_per_unit_X * x_budget + cost_per_unit_Y * y_budget;

% Objective
solve minimize total_cost;

output [
  "x_budget = ", show(x_budget), "\n",
  "y_budget = ", show(y_budget), "\n",
  "total_cost = ", show(total_cost), "\n"
];
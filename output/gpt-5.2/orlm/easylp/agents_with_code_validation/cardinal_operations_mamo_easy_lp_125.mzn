% Parameters
int: min_total_classes = 50;        % Minimum combined classes (X + Y)
int: max_math_minus_science = 20;   % Upper bound on (X - Y)
int: cost_math = 4;                % Cost per Math class
int: cost_science = 3;             % Cost per Science class

% Variables
var 0..1000: x_math;               % Number of Math classes (non-negative integer)
var 0..1000: y_science;            % Number of Science classes (non-negative integer)
var 0..100000: total_cost;         % Total cost to minimize

% Constraints
% Minimum total number of classes
constraint x_math + y_science >= min_total_classes;

% Math classes not more than twice Science classes
constraint x_math <= 2 * y_science;

% Difference between Math and Science classes bounded
constraint x_math - y_science <= max_math_minus_science;

% Define total cost
constraint total_cost = cost_math * x_math + cost_science * y_science;

% Objective
solve minimize total_cost;

% Optional output (kept simple and self-contained)
output [
  "x_math=", show(x_math), "\n",
  "y_science=", show(y_science), "\n",
  "total_cost=", show(total_cost), "\n"
];
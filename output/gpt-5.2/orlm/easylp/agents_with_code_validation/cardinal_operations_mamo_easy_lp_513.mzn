% Parameters
int: cost_x1 = 50;          % Cost per unit for project X1
int: cost_x2 = 75;          % Cost per unit for project X2
int: cost_x3 = 120;         % Cost per unit for project X3

int: total_alloc_max = 500; % Maximum combined allocation across all projects

int: eff_x1 = 5;            % Effectiveness coefficient for X1
int: eff_x2 = 10;           % Effectiveness coefficient for X2
int: eff_min = 1000;        % Minimum required effectiveness

int: diff_max = 300;        % Maximum allowed value for (2.5*X3 - X1)

% Since variables must be integers and 2.5 introduces fractions, multiply the constraint by 2:
% 2*(2.5*X3 - X1) <= 2*300  =>  5*X3 - 2*X1 <= 600
int: diff_scaled_max = 2 * diff_max;  % 600

% Project-specific bounds (assume non-negative, capped by total allocation maximum)
int: x1_lb = 0;
int: x2_lb = 0;
int: x3_lb = 0;
int: x1_ub = total_alloc_max;
int: x2_ub = total_alloc_max;
int: x3_ub = total_alloc_max;

% Variables
var x1_lb..x1_ub: x1;       % Integer resource units allocated to project X1
var x2_lb..x2_ub: x2;       % Integer resource units allocated to project X2
var x3_lb..x3_ub: x3;       % Integer resource units allocated to project X3

% Total cost (bounded safely using upper bounds of decision variables)
var 0..(cost_x1*x1_ub + cost_x2*x2_ub + cost_x3*x3_ub): total_cost;


% Constraints

% Total allocation limit across all projects
constraint x1 + x2 + x3 <= total_alloc_max;

% Minimum required effectiveness from projects X1 and X2
constraint eff_x1 * x1 + eff_x2 * x2 >= eff_min;

% Scaled difference constraint to avoid fractional coefficient:
% 2.5*X3 - X1 <= diff_max  <=>  5*X3 - 2*X1 <= 2*diff_max
constraint 5 * x3 - 2 * x1 <= diff_scaled_max;

% Define total cost from allocations and per-unit costs
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3;


% Objective
solve minimize total_cost;

% Optional: helpful output
output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), "\n",
  "total_cost=", show(total_cost), "\n"
];
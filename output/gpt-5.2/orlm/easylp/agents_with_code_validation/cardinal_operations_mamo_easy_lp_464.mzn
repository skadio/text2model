% Parameters
int: max_total_units = 1000;          % Transportation capacity limit: x + y <= 1000
int: min_weighted_demand = 1500;      % Demand requirement: 2*x + 3*y >= 1500
int: max_diff_units = 300;            % Balance requirement: |x - y| <= 300

int: cost_x = 10;                     % Cost per unit from warehouse X
int: cost_y = 15;                     % Cost per unit from warehouse Y

int: max_x_units = 700;               % Capacity of warehouse X
int: max_y_units = 500;               % Capacity of warehouse Y

% Variables
var 0..max_x_units: units_x;          % Integer units distributed from warehouse X
var 0..max_y_units: units_y;          % Integer units distributed from warehouse Y

% Upper bound on cost using max capacities (safe, tight enough for this model)
var 0..(cost_x * max_x_units + cost_y * max_y_units): total_cost; % Total distribution cost ($)

% Constraints
% Transportation capacity: total distributed units cannot exceed limit
constraint units_x + units_y <= max_total_units;

% Demand satisfaction: weighted sum of units must meet minimum demand
constraint 2 * units_x + 3 * units_y >= min_weighted_demand;

% Balance requirement: absolute difference between warehouse distributions is bounded
constraint abs(units_x - units_y) <= max_diff_units;

% Total cost definition: compute cost from both warehouses
constraint total_cost = cost_x * units_x + cost_y * units_y;

% Objective
solve minimize total_cost;
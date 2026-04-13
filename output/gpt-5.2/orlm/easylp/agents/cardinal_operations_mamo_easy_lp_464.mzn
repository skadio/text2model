% Parameters
int: max_total_units = 1000;          % Transportation constraint: total units from X and Y
int: min_weighted_demand = 1500;      % Demand constraint: 2*X + 3*Y must be at least this
int: max_diff_units = 300;            % Balance constraint: |X - Y| must not exceed this

int: cost_per_unit_x = 10;            % Cost per unit from warehouse X
int: cost_per_unit_y = 15;            % Cost per unit from warehouse Y

int: max_units_x = 700;               % Capacity upper bound for warehouse X
int: max_units_y = 500;               % Capacity upper bound for warehouse Y


% Variables
var 0..max_units_x: units_x;          % Integer units distributed from warehouse X
var 0..max_units_y: units_y;          % Integer units distributed from warehouse Y

var 0..(cost_per_unit_x*max_units_x + cost_per_unit_y*max_units_y): total_cost;
                                       % Total cost to minimize (bounded explicitly)


% Constraints
% --- Transportation capacity: total shipped units cannot exceed limit ---
constraint units_x + units_y <= max_total_units;

% --- Demand satisfaction: weighted combination must meet minimum demand ---
constraint 2 * units_x + 3 * units_y >= min_weighted_demand;

% --- Balance between warehouses: absolute difference limited ---
constraint abs(units_x - units_y) <= max_diff_units;

% --- Total cost definition: link decision variables to total_cost ---
constraint total_cost = cost_per_unit_x * units_x + cost_per_unit_y * units_y;


% Objective
solve minimize total_cost;
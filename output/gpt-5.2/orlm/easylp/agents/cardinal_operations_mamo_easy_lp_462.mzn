% Parameters
% Logistics and operational constraints (embedded data; no .dzn expected)
int: max_total_resources = 1000;          % X + Y <= 1000
int: min_weighted_capacity = 2500;        % 3*X + 2*Y >= 2500
int: max_allocation_diff = 300;           % |X - Y| <= 300

% Unit costs
int: cost_per_unit_X = 7;                 % $/unit in warehouse X
int: cost_per_unit_Y = 5;                 % $/unit in warehouse Y


% Variables
var 0..max_total_resources: x;            % units allocated to warehouse X (integer)
var 0..max_total_resources: y;            % units allocated to warehouse Y (integer)

% Upper bound: worst case when both x,y at max_total_resources
var 0..(cost_per_unit_X*max_total_resources + cost_per_unit_Y*max_total_resources): total_cost;
                                         % total cost = 7*x + 5*y


% Constraints
% Total resources limit: combined allocation cannot exceed logistics cap
constraint x + y <= max_total_resources;

% Minimum weighted capacity requirement: ensure delivery needs are met
constraint 3 * x + 2 * y >= min_weighted_capacity;

% Operational balance: allocation difference bounded in absolute value
constraint abs(x - y) <= max_allocation_diff;

% Total cost definition: linear cost from both warehouses
constraint total_cost = cost_per_unit_X * x + cost_per_unit_Y * y;


% Objective
solve minimize total_cost;
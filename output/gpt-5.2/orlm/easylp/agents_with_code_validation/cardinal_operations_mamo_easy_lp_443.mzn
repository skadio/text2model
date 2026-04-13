% Parameters
int: max_total_qty = 1000;          % Storage limit: X + Y <= 1000
int: min_balance = 300;             % Balance constraint: X - 2Y >= 300
int: min_demand = 500;              % Demand constraint: 3X + Y >= 500

int: cost_x = 5;                    % Unit cost of product X
int: cost_y = 2;                    % Unit cost of product Y

int: x_lb = 0;                      % Lower bound for X
int: x_ub = 600;                    % Upper bound for X
int: y_lb = 0;                      % Lower bound for Y
int: y_ub = 500;                    % Upper bound for Y

% Variables
var x_lb..x_ub: x_qty;              % Integer quantity of product X
var y_lb..y_ub: y_qty;              % Integer quantity of product Y

% Total cost (bounded using max possible within variable domains)
var 0..(cost_x * x_ub + cost_y * y_ub): total_cost;

% Constraints
% Storage capacity constraint: total stock cannot exceed limit
constraint x_qty + y_qty <= max_total_qty;

% Inventory balance constraint: maintain required difference between X and Y
constraint x_qty - 2 * y_qty >= min_balance;

% Demand satisfaction constraint: ensure minimum combined demand coverage
constraint 3 * x_qty + y_qty >= min_demand;

% Total cost definition: compute total cost from chosen quantities
constraint total_cost = cost_x * x_qty + cost_y * y_qty;

% Objective
solve minimize total_cost;
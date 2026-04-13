% Parameters
int: min_total_goods = 1000;        % Minimum total goods to distribute
int: capacity_limit = 2500;         % Upper bound on 2*X + Y (transport capacity)
int: cost_per_unit_x = 5;           % Cost per unit shipped to warehouse X
int: cost_per_unit_y = 3;           % Cost per unit shipped to warehouse Y

% Variables
var 0..capacity_limit: goods_x;     % Whole units shipped to warehouse X (nonnegative)
var 0..capacity_limit: goods_y;     % Whole units shipped to warehouse Y (nonnegative)
var 0..(cost_per_unit_x * capacity_limit + cost_per_unit_y * capacity_limit): total_cost;
                                   % Total transport cost upper-bounded safely

% Constraints
%--- Demand fulfillment: ship at least the required total amount
constraint goods_x + goods_y >= min_total_goods;

%--- Transport capacity: doubled X plus Y must not exceed the capacity limit
constraint 2 * goods_x + goods_y <= capacity_limit;

%--- Cost accounting: compute total transportation cost from shipments
constraint total_cost = cost_per_unit_x * goods_x + cost_per_unit_y * goods_y;

% Objective
solve minimize total_cost;
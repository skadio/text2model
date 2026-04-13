% Parameters
% Problem constants embedded directly in the model (no external data files).
int: min_demand = 50;                 % Minimum required value of 2*X + Y
int: max_overstock = 150;             % Maximum allowed value of X + 3*Y
int: profit_x = 10;                   % Profit per unit of product X
int: profit_y = 5;                    % Profit per unit of product Y

% Variables
% Decision variables: integer units of each product (non-negative).
var 0..max_overstock: x_units;        % Units of product X
var 0..max_overstock: y_units;        % Units of product Y
var int: total_profit;                % Total profit (to be maximized)

% Constraints
% --- Profit definition ---
% Total profit is computed from per-unit profits and chosen unit counts.
constraint total_profit = profit_x * x_units + profit_y * y_units;

% --- Demand satisfaction constraint ---
% Ensure minimum combined demand: 2*X + Y >= min_demand.
constraint 2 * x_units + y_units >= min_demand;

% --- Overstock/storage constraint ---
% Prevent overstocking: X + 3*Y <= max_overstock.
constraint x_units + 3 * y_units <= max_overstock;

% Objective
solve maximize total_profit;
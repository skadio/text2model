% Parameters
int: min_demand = 50;                 % Minimum required: 2*X + Y >= 50
int: max_storage = 150;               % Maximum allowed: X + 3*Y <= 150
int: profit_x = 10;                   % Profit per unit of product X
int: profit_y = 5;                    % Profit per unit of product Y

% Upper bounds derived from constraints and non-negativity
int: max_x = 150;                     % From X + 3Y <= 150 with Y >= 0 => X <= 150
int: max_y = 50;                      % From X + 3Y <= 150 with X >= 0 => Y <= 50

% Variables
var 0..max_x: x_units;                % Integer units of product X
var 0..max_y: y_units;                % Integer units of product Y
var 0..(profit_x * max_x + profit_y * max_y): total_profit;  % Total profit

% Constraints
constraint 2 * x_units + y_units >= min_demand;             % Demand satisfaction
constraint x_units + 3 * y_units <= max_storage;            % Storage limitation
constraint total_profit = profit_x * x_units + profit_y * y_units;  % Profit definition

% Objective
solve maximize total_profit;
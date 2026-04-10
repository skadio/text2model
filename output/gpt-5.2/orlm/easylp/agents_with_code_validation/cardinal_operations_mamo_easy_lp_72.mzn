% Parameters
int: profit_wheat = 5;                 % Profit per unit land for Wheat ($/unit)
int: profit_corn  = 3;                 % Profit per unit land for Corn ($/unit)

int: limit_total = 1000;               % Maximum allowed weighted total under equipment/manpower limit
int: weight_wheat = 2;                 % Weight coefficient for Wheat in the limit constraint
int: weight_corn  = 4;                 % Weight coefficient for Corn in the limit constraint

int: min_wheat_minus_corn = 100;       % Wheat must exceed Corn by at least this many units

% Variables
var 0..limit_total: land_wheat;        % Integer units of land allocated to Wheat
var 0..limit_total: land_corn;         % Integer units of land allocated to Corn

var 0..(profit_wheat*limit_total + profit_corn*limit_total): total_profit;  % Total profit in dollars

% Constraints
% Compute total profit from land allocations
constraint
  total_profit = profit_wheat * land_wheat + profit_corn * land_corn;

% Equipment/manpower weighted capacity constraint
constraint
  weight_wheat * land_wheat + weight_corn * land_corn <= limit_total;

% Market preference constraint: Wheat allocation must exceed Corn by at least a minimum margin
constraint
  land_wheat - land_corn >= min_wheat_minus_corn;

% Objective
solve minimize total_profit;
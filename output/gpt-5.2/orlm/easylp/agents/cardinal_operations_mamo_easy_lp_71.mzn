% Parameters
int: total_acres = 100;                 % Total available land (acres)
int: profit_per_acre_wheat = 20;        % Profit per acre of wheat ($/acre)
int: profit_per_acre_corn  = 30;        % Profit per acre of corn ($/acre)

int: wheat_coeff = 3;                   % Coefficient for wheat in demand/regulation constraint
int: corn_coeff  = 2;                   % Coefficient for corn in demand/regulation constraint
int: min_units   = 200;                 % Minimum required combined units

% Variables
var 0..total_acres: acres_wheat;        % Acres allocated to wheat (integer, bounded)
var 0..total_acres: acres_corn;         % Acres allocated to corn (integer, bounded)

var 0..(profit_per_acre_wheat*total_acres + profit_per_acre_corn*total_acres): total_profit;
% Total profit ($), safe loose upper bound

% Constraints
% Land allocation constraint: cannot exceed total available acres
constraint
  acres_wheat + acres_corn <= total_acres;

% Demand/regulation constraint: combined units from crops must meet minimum requirement
constraint
  wheat_coeff * acres_wheat + corn_coeff * acres_corn >= min_units;

% Total profit definition: link total_profit to chosen acreage allocations
constraint
  total_profit =
    profit_per_acre_wheat * acres_wheat +
    profit_per_acre_corn  * acres_corn;

% Objective
solve maximize total_profit;
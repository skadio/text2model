% Parameters
int: profit_wheat = 5;                 % Profit per unit land for Wheat ($)
int: profit_corn  = 3;                 % Profit per unit land for Corn ($)

int: max_equipment_limit = 1000;       % Maximum limit for combined equipment/manpower usage
int: wheat_coeff = 2;                  % Coefficient for Wheat in equipment constraint
int: corn_coeff  = 4;                  % Coefficient for Corn in equipment constraint

int: min_wheat_minus_corn = 100;       % Wheat must exceed Corn by at least this many units

% Upper bounds for decision variables derived from equipment constraint
int: max_wheat = max_equipment_limit div wheat_coeff;   % since 2*wheat <= 1000
int: max_corn  = max_equipment_limit div corn_coeff;    % since 4*corn  <= 1000

% Variables
var 0..max_wheat: wheat_land;          % Integer units of land allocated to Wheat
var 0..max_corn:  corn_land;           % Integer units of land allocated to Corn

var 0..(profit_wheat*max_wheat + profit_corn*max_corn): total_profit;  % Total profit ($)

% Constraints

% Link total profit to land allocations
constraint
  total_profit = profit_wheat * wheat_land + profit_corn * corn_land;

% Equipment/manpower usage limit (combined constraint)
constraint
  wheat_coeff * wheat_land + corn_coeff * corn_land <= max_equipment_limit;

% Wheat must exceed Corn by at least the required minimum
constraint
  wheat_land - corn_land >= min_wheat_minus_corn;

% Objective
solve minimize total_profit;
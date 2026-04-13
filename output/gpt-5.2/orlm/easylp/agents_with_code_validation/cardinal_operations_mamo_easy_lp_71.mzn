% Parameters
int: total_acres = 100;                 % Total available land (acres)
int: profit_wheat = 20;                 % Profit per acre of wheat ($/acre)
int: profit_corn  = 30;                 % Profit per acre of corn ($/acre)

int: coeff_wheat_requirement = 3;       % Requirement coefficient for wheat
int: coeff_corn_requirement  = 2;       % Requirement coefficient for corn
int: min_required_units      = 200;     % Minimum required combined units

% Variables
var 0..total_acres: acres_wheat;        % Acres allocated to wheat
var 0..total_acres: acres_corn;         % Acres allocated to corn

% Upper bound: if all acres go to the most profitable crop
var 0..(total_acres * max(profit_wheat, profit_corn)): total_profit; % Total profit ($)

% Constraints
% Land allocation constraint: total acres used cannot exceed available land
constraint acres_wheat + acres_corn <= total_acres;

% Production/requirement constraint: combined units must meet minimum requirement
constraint
  coeff_wheat_requirement * acres_wheat + coeff_corn_requirement * acres_corn
  >= min_required_units;

% Total profit definition constraint: link decision variables to computed profit
constraint total_profit = profit_wheat * acres_wheat + profit_corn * acres_corn;

% Objective
solve maximize total_profit;
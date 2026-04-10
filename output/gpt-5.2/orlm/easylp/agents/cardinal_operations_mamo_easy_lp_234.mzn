% Parameters
int: profit_corn = 3;        % Profit per acre of Corn ($/acre)
int: profit_wheat = 4;       % Profit per acre of Wheat ($/acre)
int: profit_soybean = 5;     % Profit per acre of Soybean ($/acre)

int: limit_corn_wheat = 15000;   % Upper bound for 2*Corn + 3*Wheat
int: min_total_acres = 8000;     % Minimum total acreage across all crops
int: max_diff_wheat_soy = 2000;  % Maximum allowed |Wheat - Soybean|

% Variables
var 0..15000: acres_corn;      % Acres allocated to Corn (integer, non-negative)
var 0..15000: acres_wheat;     % Acres allocated to Wheat (integer, non-negative)
var 0..15000: acres_soybean;   % Acres allocated to Soybean (integer, non-negative)

% Total profit (bounded by max possible profit given variable upper bounds)
var 0..(profit_corn*15000 + profit_wheat*15000 + profit_soybean*15000): total_profit;

% Constraints
% Land/irrigation limitation: 2*Corn + 3*Wheat <= limit
constraint
  2 * acres_corn + 3 * acres_wheat <= limit_corn_wheat;

% Crop diversity / minimum utilization: total acres across all crops >= minimum
constraint
  acres_corn + acres_wheat + acres_soybean >= min_total_acres;

% Risk management: |Wheat - Soybean| <= max allowed difference
constraint
  abs(acres_wheat - acres_soybean) <= max_diff_wheat_soy;

% Define total profit from chosen acre allocations
constraint
  total_profit =
    profit_corn * acres_corn +
    profit_wheat * acres_wheat +
    profit_soybean * acres_soybean;

% Objective
solve minimize total_profit;
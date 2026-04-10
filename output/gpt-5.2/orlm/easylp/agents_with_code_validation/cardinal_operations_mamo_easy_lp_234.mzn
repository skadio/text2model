% Parameters
% Profits per acre (in dollars)
int: profit_corn = 3;
int: profit_wheat = 4;
int: profit_soybean = 5;

% Constraint coefficients and limits
int: max_weighted_corn_wheat = 15000;   % 2*corn + 3*wheat <= 15000
int: min_total_acres = 8000;            % corn + wheat + soybean >= 8000
int: max_wheat_soy_diff = 2000;         % |wheat - soybean| <= 2000

% Variables
% Acreages are integers (MiniZinc vars over integer domains)
var 0..(max_weighted_corn_wheat div 2): acres_corn;                 % acres of Corn
var 0..(max_weighted_corn_wheat div 3): acres_wheat;                % acres of Wheat
var 0..(min_total_acres + max_wheat_soy_diff): acres_soybean;       % acres of Soybean

var int: total_profit; % total profit in dollars

% Constraints
% Link total_profit to chosen acreages and per-acre profits
constraint
  total_profit =
    profit_corn * acres_corn +
    profit_wheat * acres_wheat +
    profit_soybean * acres_soybean;

% Land/irrigation (or soil) limitation on weighted Corn and Wheat acres
constraint
  2 * acres_corn + 3 * acres_wheat <= max_weighted_corn_wheat;

% Minimum total acreage requirement to ensure crop diversity / utilization
constraint
  acres_corn + acres_wheat + acres_soybean >= min_total_acres;

% Risk management: Wheat and Soybean acreages must be close (bounded difference)
constraint
  abs(acres_wheat - acres_soybean) <= max_wheat_soy_diff;

% Objective
solve minimize total_profit;
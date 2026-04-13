% Parameters
% Profit per acre for each crop (USD/acre)
int: profit_wheat   = 4;
int: profit_corn    = 3;
int: profit_soybean = 2;
int: profit_rice    = 1;

% Joint area limits (acres)
int: max_wheat_corn = 1000;  % Wheat + Corn
int: max_soy_rice   = 800;   % Soybean + Rice

% Diversity / balance requirements (acres)
int: min_wheat_over_soy = 200;   % Wheat - Soybean >= 200
int: max_corn_rice_diff = 500;   % |Corn - Rice| <= 500

% Individual crop maximums (acres)
int: max_wheat   = 600;
int: max_corn    = 400;
int: max_soybean = 350;
int: max_rice    = 300;


% Variables
% Acres allocated to each crop (must be whole numbers, can be zero)
var 0..max_wheat:   acres_wheat;
var 0..max_corn:    acres_corn;
var 0..max_soybean: acres_soybean;
var 0..max_rice:    acres_rice;

% Total profit (USD)
int: max_total_profit =
  profit_wheat*max_wheat + profit_corn*max_corn + profit_soybean*max_soybean + profit_rice*max_rice;
var 0..max_total_profit: total_profit;

% Total cost (negative profit) for "minimum total cost" reporting
var -max_total_profit..0: total_cost;


% Constraints
% --- Profit / cost accounting constraints ---
% Define total profit as the sum of per-acre profits times allocated acres
constraint
  total_profit =
    profit_wheat   * acres_wheat +
    profit_corn    * acres_corn +
    profit_soybean * acres_soybean +
    profit_rice    * acres_rice;

% Define total cost as negative profit (for "minimum total cost" reporting)
constraint
  total_cost = -total_profit;

% --- Joint area limit constraints ---
% Combined acreage for Wheat and Corn cannot exceed the joint limit
constraint
  acres_wheat + acres_corn <= max_wheat_corn;

% Combined acreage for Soybean and Rice cannot exceed the joint limit
constraint
  acres_soybean + acres_rice <= max_soy_rice;

% --- Diversity / balance constraints ---
% Wheat must be at least a certain amount greater than Soybean
constraint
  acres_wheat - acres_soybean >= min_wheat_over_soy;

% Corn and Rice acreage difference must be within the allowed bound
constraint
  abs(acres_corn - acres_rice) <= max_corn_rice_diff;


% Objective
solve maximize total_profit;

output [
  "acres_wheat=", show(acres_wheat), "\n",
  "acres_corn=", show(acres_corn), "\n",
  "acres_soybean=", show(acres_soybean), "\n",
  "acres_rice=", show(acres_rice), "\n",
  "total_profit=", show(total_profit), "\n",
  "total_cost=", show(total_cost), "\n"
];
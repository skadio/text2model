% Parameters
% Net profit per acre (USD) for each crop (embedded from problem statement)
int: profit_wheat   = 4;
int: profit_corn    = 3;
int: profit_soybean = 2;
int: profit_rice    = 1;

% Combined area limits (acres)
int: max_wheat_corn_total   = 1000;  % Wheat + Corn <= 1000
int: max_soybean_rice_total = 800;   % Soybean + Rice <= 800

% Diversity / difference requirements (acres)
int: min_wheat_minus_soybean = 200;  % Wheat - Soybean >= 200
int: max_corn_minus_rice_abs = 500;  % |Corn - Rice| <= 500

% Individual crop maximum areas (acres)
int: max_wheat   = 600;
int: max_corn    = 400;
int: max_soybean = 350;
int: max_rice    = 300;


% Variables
% Acres allocated to each crop (must be whole numbers, no explicit lower bounds => >= 0)
var 0..max_wheat:   acres_wheat;    % acres of Wheat
var 0..max_corn:    acres_corn;     % acres of Corn
var 0..max_soybean: acres_soybean;  % acres of Soybean
var 0..max_rice:    acres_rice;     % acres of Rice

% Total profit (USD), integer-valued
var 0..(profit_wheat*max_wheat
      + profit_corn*max_corn
      + profit_soybean*max_soybean
      + profit_rice*max_rice): total_profit;

% Total cost to minimize (negative profit, for "minimum total cost" wording)
var -(profit_wheat*max_wheat
    + profit_corn*max_corn
    + profit_soybean*max_soybean
    + profit_rice*max_rice)..0: total_cost;


% Constraints
% --- Combined area limit constraints ---
% Wheat + Corn cannot exceed the specified combined cap
constraint acres_wheat + acres_corn <= max_wheat_corn_total;

% Soybean + Rice cannot exceed the specified combined cap
constraint acres_soybean + acres_rice <= max_soybean_rice_total;

% --- Diversity / difference constraints ---
% Ensure at least min_wheat_minus_soybean more acres of Wheat than Soybean
constraint acres_wheat - acres_soybean >= min_wheat_minus_soybean;

% Ensure the absolute difference between Corn and Rice is within the allowed bound
constraint abs(acres_corn - acres_rice) <= max_corn_minus_rice_abs;

% --- Accounting constraints (linking variables) ---
% Define total profit from allocated acres
constraint total_profit =
    profit_wheat   * acres_wheat +
    profit_corn    * acres_corn +
    profit_soybean * acres_soybean +
    profit_rice    * acres_rice;

% Define total cost as negative profit (for "min total cost" phrasing)
constraint total_cost = -total_profit;


% Objective
solve minimize total_cost;

output [
  "acres_wheat=", show(acres_wheat), "\n",
  "acres_corn=", show(acres_corn), "\n",
  "acres_soybean=", show(acres_soybean), "\n",
  "acres_rice=", show(acres_rice), "\n",
  "total_profit=", show(total_profit), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];
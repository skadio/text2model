% Parameters
% Cost per bag (per acre) for each crop (in dollars)
int: cost_corn = 50;
int: cost_wheat = 30;
int: cost_soybean = 20;

% Requirement thresholds
int: food_security_min = 1000;      % 2*Corn + Wheat >= 1000
int: soil_health_max = 5000;        % Wheat + Soybean <= 5000
int: corn_over_soy_min = 1000;      % Corn - Soybean >= 1000

% Upper bounds (safe big-M style bounds derived from constraints)
int: max_wheat = soil_health_max;                 % Wheat <= 5000
int: max_soybean = soil_health_max;               % Soybean <= 5000
int: max_corn = max_soybean + corn_over_soy_min;  % Corn <= 6000

% Variables
var 0..max_corn: Corn;         % bags of corn seed (acres of corn), integer
var 0..max_wheat: Wheat;       % bags of wheat seed (acres of wheat), integer
var 0..max_soybean: Soybean;   % bags of soybean seed (acres of soybean), integer

% Total seed cost (dollars)
var 0..(cost_corn*max_corn + cost_wheat*max_wheat + cost_soybean*max_soybean): TotalCost;

% Constraints

% --- Food security constraint: ensure enough corn and wheat acreage ---
constraint 2 * Corn + Wheat >= food_security_min;

% --- Soil health constraint: cap combined wheat and soybean acreage ---
constraint Wheat + Soybean <= soil_health_max;

% --- Market demand constraint: corn must exceed soybean by at least a margin ---
constraint Corn - Soybean >= corn_over_soy_min;

% --- Total cost definition: compute total dollars spent on seeds ---
constraint TotalCost = cost_corn * Corn + cost_wheat * Wheat + cost_soybean * Soybean;

% Objective
solve minimize TotalCost;
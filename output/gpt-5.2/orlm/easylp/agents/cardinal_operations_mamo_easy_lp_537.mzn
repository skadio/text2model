% Parameters
% Costs per bag (each bag covers one acre)
int: cost_corn    = 50;
int: cost_wheat   = 30;
int: cost_soybean = 20;

% Constraint thresholds
int: food_security_min = 1000;   % 2*Corn + Wheat >= 1000
int: max_wheat_soy     = 5000;   % Wheat + Soybean <= 5000
int: corn_over_soy_min = 1000;   % Corn - Soybean >= 1000


% Variables
% Acres/bags planted for each crop (whole bags only, non-negative)
var 0..100000: Corn;      % number of corn bags/acres
var 0..100000: Wheat;     % number of wheat bags/acres
var 0..100000: Soybean;   % number of soybean bags/acres

% Total cost (integer dollars)
var 0..1000000000: TotalCost;


% Constraints
% Food security requirement: 2*Corn + Wheat >= minimum threshold
constraint
  2 * Corn + Wheat >= food_security_min;

% Soil health requirement: Wheat + Soybean <= maximum allowed
constraint
  Wheat + Soybean <= max_wheat_soy;

% Market demand requirement: Corn must exceed Soybean by at least the minimum gap
constraint
  Corn - Soybean >= corn_over_soy_min;

% Total cost definition: linear cost based on per-bag costs
constraint
  TotalCost = cost_corn * Corn + cost_wheat * Wheat + cost_soybean * Soybean;


% Objective
solve minimize TotalCost;
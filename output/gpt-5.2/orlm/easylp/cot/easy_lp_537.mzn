% Parameters (with values embedded)
int: min_food_security = 1000;         % 2*Corn + Wheat >= 1000
int: max_wheat_soy = 5000;             % Wheat + Soybean <= 5000
int: min_corn_minus_soy = 1000;        % Corn - Soybean >= 1000

int: cost_corn = 50;
int: cost_wheat = 30;
int: cost_soybean = 20;

% Variables
var 0..100000: Corn;
var 0..100000: Wheat;
var 0..100000: Soybean;

var 0..intmax: TotalCost;

% Constraints
constraint 2 * Corn + Wheat >= min_food_security;
constraint Wheat + Soybean <= max_wheat_soy;
constraint Corn - Soybean >= min_corn_minus_soy;

constraint TotalCost = cost_corn * Corn + cost_wheat * Wheat + cost_soybean * Soybean;

% Objective
solve minimize TotalCost;
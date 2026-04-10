% Parameters
int: cost_corn = 50;
int: cost_wheat = 30;
int: cost_soybean = 20;

int: food_security_min = 1000;        % 2*Corn + Wheat >= 1000
int: wheat_soy_max = 5000;            % Wheat + Soybean <= 5000
int: corn_minus_soy_min = 1000;       % Corn - Soybean >= 1000

% Variables
var 0..100000: Corn;
var 0..100000: Wheat;
var 0..100000: Soybean;

var 0..100000000: TotalCost;

% Constraints
constraint 2 * Corn + Wheat >= food_security_min;
constraint Wheat + Soybean <= wheat_soy_max;
constraint Corn - Soybean >= corn_minus_soy_min;

constraint TotalCost = cost_corn * Corn + cost_wheat * Wheat + cost_soybean * Soybean;

% Objective
solve minimize TotalCost;
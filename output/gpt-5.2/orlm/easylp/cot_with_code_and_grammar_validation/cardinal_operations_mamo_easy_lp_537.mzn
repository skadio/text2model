% Parameters
int: corn_cost = 50;
int: wheat_cost = 30;
int: soybean_cost = 20;

int: food_security_min = 1000;      % 2*Corn + Wheat >= 1000
int: soil_health_max = 5000;        % Wheat + Soybean <= 5000
int: corn_minus_soy_min = 1000;     % Corn - Soybean >= 1000

% Variables
var 0..5000: Corn;
var 0..5000: Wheat;
var 0..5000: Soybean;

var 0..(corn_cost*5000 + wheat_cost*5000 + soybean_cost*5000): TotalCost;

% Constraints
constraint 2 * Corn + Wheat >= food_security_min;
constraint Wheat + Soybean <= soil_health_max;
constraint Corn - Soybean >= corn_minus_soy_min;

constraint TotalCost = corn_cost * Corn + wheat_cost * Wheat + soybean_cost * Soybean;

% Objective
solve minimize TotalCost;
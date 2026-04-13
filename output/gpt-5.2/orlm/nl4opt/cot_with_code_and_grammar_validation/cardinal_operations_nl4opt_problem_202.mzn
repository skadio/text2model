% Parameters
int: total_hectares = 140;
int: min_tomatoes = 20;
int: min_potatoes = 30;
int: profit_tomatoes = 350;
int: profit_potatoes = 600;

% Variables
var 0..total_hectares: tomatoes;
var 0..total_hectares: potatoes;
var 0..(profit_tomatoes*total_hectares + profit_potatoes*total_hectares): total_profit;

% Constraints
constraint tomatoes + potatoes <= total_hectares;

constraint tomatoes >= min_tomatoes;
constraint potatoes >= min_potatoes;

constraint tomatoes > potatoes;
constraint tomatoes <= 2 * potatoes;

constraint total_profit = profit_tomatoes * tomatoes + profit_potatoes * potatoes;

% Objective
solve maximize total_profit;
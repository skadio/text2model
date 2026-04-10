% Parameters (with values embedded)
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
constraint tomatoes > potatoes;                  % prefers more tomatoes than potatoes
constraint tomatoes <= 2 * potatoes;             % at most twice tomatoes as potatoes
constraint tomatoes >= min_tomatoes;
constraint potatoes >= min_potatoes;

% Objective
constraint total_profit = profit_tomatoes * tomatoes + profit_potatoes * potatoes;
solve maximize total_profit;

output [
  "tomatoes_hectares=", show(tomatoes), "\n",
  "potatoes_hectares=", show(potatoes), "\n",
  "profit=", show(total_profit), "\n"
];
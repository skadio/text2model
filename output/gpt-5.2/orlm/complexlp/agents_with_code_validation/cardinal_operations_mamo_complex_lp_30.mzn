% Parameters
int: nFoods = 5;                          % number of available food items
set of int: FOODS = 1..nFoods;            % index set for foods

array[FOODS] of int: protein  = [8, 10, 3, 16, 4];         % grams of protein per unit
array[FOODS] of int: carbs    = [8, 30, 10, 29, 24];       % grams of carbohydrates per unit
array[FOODS] of int: calories = [118, 131, 151, 235, 101]; % calories per unit
array[FOODS] of int: price    = [6, 10, 1, 9, 4];          % cost per unit ($)

int: minProtein  = 93;                    % minimum required protein
int: minCarbs    = 181;                   % minimum required carbohydrates
int: minCalories = 1620;                  % minimum required calories

% Variables
array[FOODS] of var 0..1000: qty;         % units chosen of each food (non-negative integers)
var 0..1000000: totalCost;                % total cost to minimize

% Constraints
% Total cost definition
constraint totalCost = sum(f in FOODS)(price[f] * qty[f]);

% Nutritional requirements: meet or exceed daily minimums
constraint sum(f in FOODS)(protein[f]  * qty[f]) >= minProtein;
constraint sum(f in FOODS)(carbs[f]    * qty[f]) >= minCarbs;
constraint sum(f in FOODS)(calories[f] * qty[f]) >= minCalories;

% Objective
solve minimize totalCost;

% Output only the optimal objective value (minimum cost)
output [show(totalCost)];
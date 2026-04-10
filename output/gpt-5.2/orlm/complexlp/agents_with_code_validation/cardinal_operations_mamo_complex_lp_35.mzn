% Parameters
int: nFoods = 7;                                   % Number of available foods
set of int: FOODS = 1..nFoods;                     % Food index set

array[FOODS] of int: cost     = [6, 2, 10, 6, 4, 1, 9];              % Cost per unit of each food
array[FOODS] of int: protein  = [6, 16, 12, 9, 12, 12, 13];          % Protein grams per unit
array[FOODS] of int: carbs    = [3, 3, 17, 28, 17, 14, 20];          % Carbohydrates grams per unit
array[FOODS] of int: calories = [73, 181, 231, 160, 209, 184, 118];  % Calories per unit

int: minProtein  = 59;                             % Minimum required protein
int: minCarbs    = 179;                            % Minimum required carbohydrates
int: minCalories = 2414;                           % Minimum required calories

% A safe upper bound on servings per food (enough to meet any requirement using the "best" (minimum-per-unit) nutrient food)
int: maxServings = max(
  [ (minProtein  + min(protein)  - 1) div min(protein),
    (minCarbs    + min(carbs)    - 1) div min(carbs),
    (minCalories + min(calories) - 1) div min(calories) ]
);

% Variables
array[FOODS] of var 0..maxServings: servings;      % Integer number of units chosen of each food
var 0..(maxServings * sum(cost)): totalCost;       % Total cost of chosen foods

% Constraints
% Link totalCost to the chosen servings and unit costs
constraint totalCost = sum(f in FOODS)(servings[f] * cost[f]);

% Nutritional requirement: meet minimum total protein
constraint sum(f in FOODS)(servings[f] * protein[f]) >= minProtein;

% Nutritional requirement: meet minimum total carbohydrates
constraint sum(f in FOODS)(servings[f] * carbs[f]) >= minCarbs;

% Nutritional requirement: meet minimum total calories
constraint sum(f in FOODS)(servings[f] * calories[f]) >= minCalories;

% Objective
solve minimize totalCost;
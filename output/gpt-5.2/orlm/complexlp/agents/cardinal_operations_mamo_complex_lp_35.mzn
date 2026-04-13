% Parameters
int: nFoods = 7;                               % number of available food items
set of int: FOODS = 1..nFoods;                 % index set for foods

array[FOODS] of int: cost = [6, 2, 10, 6, 4, 1, 9];                % cost per serving
array[FOODS] of int: protein = [6, 16, 12, 9, 12, 12, 13];         % grams protein per serving
array[FOODS] of int: carbs = [3, 3, 17, 28, 17, 14, 20];           % grams carbs per serving
array[FOODS] of int: calories = [73, 181, 231, 160, 209, 184, 118];% calories per serving

int: minProtein = 59;                         % minimum required protein (g)
int: minCarbs = 179;                          % minimum required carbohydrates (g)
int: minCalories = 2414;                      % minimum required calories

% Variables
% Upper bound: in the most calorie-dense case, this many servings suffice to reach minCalories.
array[FOODS] of var 0..ceil(int2float(minCalories) / min(calories)): servings;

var int: totalCost;                           % total cost of chosen servings
var int: totalProtein;                        % total protein achieved
var int: totalCarbs;                          % total carbs achieved
var int: totalCalories;                       % total calories achieved

% Constraints
% --- Totals definition constraints (link decision variables to aggregate totals) ---
constraint totalCost = sum(i in FOODS)(cost[i] * servings[i]);
constraint totalProtein = sum(i in FOODS)(protein[i] * servings[i]);
constraint totalCarbs = sum(i in FOODS)(carbs[i] * servings[i]);
constraint totalCalories = sum(i in FOODS)(calories[i] * servings[i]);

% --- Nutritional minimum requirements (must meet or exceed weekly goals) ---
constraint totalProtein >= minProtein;
constraint totalCarbs >= minCarbs;
constraint totalCalories >= minCalories;

% Objective
solve minimize totalCost;
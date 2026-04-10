% Parameters
int: nFoods = 8;                               % number of food items
set of int: FOODS = 1..nFoods;                 % index set for foods

array[FOODS] of int: protein  = [1, 18, 19, 19, 3, 8, 15, 3];          % grams protein per unit
array[FOODS] of int: carbs    = [4, 2, 26, 10, 24, 26, 27, 30];        % grams carbs per unit
array[FOODS] of int: calories = [93, 219, 155, 105, 255, 182, 173, 191]; % calories per unit
array[FOODS] of int: cost     = [6, 4, 4, 3, 2, 7, 3, 3];              % cost per unit ($)

int: minProtein  = 98;                          % minimum required protein
int: minCarbs    = 113;                         % minimum required carbs
int: minCalories = 1768;                        % minimum required calories

% Variables
array[FOODS] of var 0..100: servings;           % integer servings chosen of each food
var 0..100000: totalCost;                       % total cost (objective)

% Constraints
%----------------------------
% Total cost definition
%----------------------------
constraint
  totalCost = sum(f in FOODS)(cost[f] * servings[f]);

%----------------------------
% Nutrition requirements (minimums)
%----------------------------
constraint
  sum(f in FOODS)(protein[f] * servings[f]) >= minProtein;

constraint
  sum(f in FOODS)(carbs[f] * servings[f]) >= minCarbs;

constraint
  sum(f in FOODS)(calories[f] * servings[f]) >= minCalories;

% Objective
solve minimize totalCost;
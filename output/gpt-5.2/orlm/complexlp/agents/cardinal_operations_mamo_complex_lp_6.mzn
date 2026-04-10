% Parameters
int: nFoods = 5;                          % number of available foods
set of int: FOODS = 1..nFoods;            % index set for foods

array[FOODS] of int: protein  = [10, 3, 17, 6, 20];        % grams protein per unit of food i
array[FOODS] of int: carbs    = [22, 4, 10, 13, 5];        % grams carbohydrates per unit of food i
array[FOODS] of int: calories = [80, 189, 153, 232, 204];  % calories per unit of food i
array[FOODS] of int: cost     = [2, 8, 4, 1, 8];           % cost ($) per unit of food i

int: minProtein  = 74;                     % minimum total protein required
int: minCarbs    = 102;                    % minimum total carbohydrates required
int: minCalories = 1564;                   % minimum total calories required

% Variables
array[FOODS] of var 0..20: x;              % number of units chosen of each food (bounded for linearity)
var 0..10000: totalCost;                   % total cost of chosen foods

% Constraints

% Link totalCost to the chosen quantities and per-unit costs
constraint
  totalCost = sum(i in FOODS)(cost[i] * x[i]);

% Nutritional requirement: meet minimum total protein
constraint
  sum(i in FOODS)(protein[i] * x[i]) >= minProtein;

% Nutritional requirement: meet minimum total carbohydrates
constraint
  sum(i in FOODS)(carbs[i] * x[i]) >= minCarbs;

% Nutritional requirement: meet minimum total calories
constraint
  sum(i in FOODS)(calories[i] * x[i]) >= minCalories;

% Objective
solve minimize totalCost;
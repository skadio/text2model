% Parameters
int: nFoods = 6;                         % number of available foods
set of int: FOODS = 1..nFoods;           % index set for foods

% Nutrient requirements (minimums)
int: reqProtein  = 88;                   % grams of protein required (min)
int: reqCarbs    = 144;                  % grams of carbohydrates required (min)
int: reqCalories = 1900;                 % calories required (min)

% Per-food nutrient contents and costs
array[FOODS] of int: protein  = [15, 16, 3, 19, 11, 10];        % grams protein per unit
array[FOODS] of int: carbs    = [10, 25, 8, 20, 8, 9];          % grams carbs per unit
array[FOODS] of int: calories = [163, 108, 198, 141, 105, 199]; % calories per unit
array[FOODS] of int: cost     = [10, 4, 1, 7, 6, 8];            % cost per unit ($)

% Variables
array[FOODS] of var 0..200: x;          % number of units of each food (bounded nonnegative integer)

var 0..100000: totalCost;               % total cost (to minimize)
var 0..100000: totalProtein;            % total protein achieved
var 0..100000: totalCarbs;              % total carbs achieved
var 0..100000: totalCalories;           % total calories achieved

% Constraints
% Compute total nutrients from chosen food quantities
constraint totalProtein  = sum(f in FOODS)(protein[f]  * x[f]);
constraint totalCarbs    = sum(f in FOODS)(carbs[f]    * x[f]);
constraint totalCalories = sum(f in FOODS)(calories[f] * x[f]);

% Meet minimum nutrient requirements
constraint totalProtein  >= reqProtein;
constraint totalCarbs    >= reqCarbs;
constraint totalCalories >= reqCalories;

% Compute total cost from chosen food quantities
constraint totalCost = sum(f in FOODS)(cost[f] * x[f]);

% Objective
solve minimize totalCost;
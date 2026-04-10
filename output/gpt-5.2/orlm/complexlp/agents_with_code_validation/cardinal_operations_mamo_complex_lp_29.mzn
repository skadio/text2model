% Parameters
int: nFoods = 4;                              % Number of foods
set of int: FOODS = 1..nFoods;                % Food index set

% Food data (order: 1=Chicken, 2=Tofu, 3=Rice, 4=Avocado)
array[FOODS] of int: protein  = [2, 18, 2, 18];        % grams of protein per unit
array[FOODS] of int: carbs    = [4, 17, 28, 27];       % grams of carbohydrates per unit
array[FOODS] of int: calories = [218, 290, 298, 158];  % calories per unit
array[FOODS] of int: cost     = [3, 6, 1, 10];         % cost ($) per unit

% Nutritional minimum requirements
int: minProtein  = 86;
int: minCarbs    = 120;
int: minCalories = 2435;

% Variables
array[FOODS] of var 0..1000: qty;              % number of units chosen of each food (non-negative)

var 0..1000000: totalCost;                     % total cost
var 0..1000000: totalProtein;                  % total protein
var 0..1000000: totalCarbs;                    % total carbs
var 0..1000000: totalCalories;                 % total calories

% Constraints
% Aggregate totals from chosen quantities
constraint totalCost     = sum(f in FOODS)(cost[f]     * qty[f]);
constraint totalProtein  = sum(f in FOODS)(protein[f]  * qty[f]);
constraint totalCarbs    = sum(f in FOODS)(carbs[f]    * qty[f]);
constraint totalCalories = sum(f in FOODS)(calories[f] * qty[f]);

% Meet minimum nutritional requirements
constraint totalProtein  >= minProtein;
constraint totalCarbs    >= minCarbs;
constraint totalCalories >= minCalories;

% Objective
solve minimize totalCost;
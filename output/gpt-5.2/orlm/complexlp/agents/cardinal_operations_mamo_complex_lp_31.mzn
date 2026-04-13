% Parameters
int: nFoods = 6;
set of int: FOODS = 1..nFoods;

array[FOODS] of string: foodName = ["Chicken","Rice","Lentils","Apples","Eggs","Broccoli"];

array[FOODS] of int: protein  = [20,  2, 10,  5, 17,  6];   % grams per unit
array[FOODS] of int: carbs    = [ 9, 15, 30, 19, 12, 18];   % grams per unit
array[FOODS] of int: calories = [89,276,255,258,212,246];   % calories per unit
array[FOODS] of int: cost     = [ 6,  8,  4,  1,  3,  5];   % dollars per unit

int: minProtein  = 90;
int: minCarbs    = 162;
int: minCalories = 1926;

% Variables
array[FOODS] of var 0..1000: qty;     % number of units of each food (nonnegative integer)
var 0..1000000: totalCost;            % total dollars spent

% Constraints
% Total cost definition
constraint
  totalCost = sum(f in FOODS)(cost[f] * qty[f]);

% Nutrition requirements: meet minimum protein
constraint
  sum(f in FOODS)(protein[f] * qty[f]) >= minProtein;

% Nutrition requirements: meet minimum carbohydrates
constraint
  sum(f in FOODS)(carbs[f] * qty[f]) >= minCarbs;

% Nutrition requirements: meet minimum calories
constraint
  sum(f in FOODS)(calories[f] * qty[f]) >= minCalories;

% Objective
solve minimize totalCost;

output [show(totalCost)];
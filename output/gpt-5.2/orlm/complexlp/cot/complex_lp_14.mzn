% Parameters (with values embedded)
int: nFoods = 8;
set of int: FOODS = 1..nFoods;

array[FOODS] of string: foodName =
  ["Eggs","Grains","Berries","Nuts","Salmon","Vegetables","Rice","Meat"];

array[FOODS] of int: cost =        [4, 3, 2, 4, 9, 3, 6, 6];
array[FOODS] of int: protein =     [2, 7, 6,16,20, 6, 6, 5];
array[FOODS] of int: carbs =       [4, 9,18, 3,11,27,30, 1];
array[FOODS] of int: calories =    [282,104,71,116,175,132,251,74];

int: reqProtein = 84;
int: reqCarbs = 195;
int: reqCalories = 1941;

% Variables
array[FOODS] of var 0..1000: x; % servings/units of each food item (integer, nonnegative)
var 0..1000000: totalCost;

% Constraints
constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i]) >= reqProtein;
constraint sum(i in FOODS)(carbs[i] * x[i]) >= reqCarbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= reqCalories;

% Objective
solve minimize totalCost;
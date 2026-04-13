% Parameters
int: nFoods = 4;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [16, 10, 12, 13];
array[FOODS] of int: carbs   = [22,  4, 21, 14];
array[FOODS] of int: calories= [292, 82, 207, 81];
array[FOODS] of int: cost    = [5,   9,  2,  1];

int: reqProtein  = 94;
int: reqCarbs    = 191;
int: reqCalories = 2271;

% Variables
array[FOODS] of var 0..2271: x; % servings of each food (non-negative integers)
var 0..(max(cost) * 2271): totalCost;

% Constraints
constraint forall(i in FOODS)(x[i] >= 0);

constraint sum(i in FOODS)(protein[i]  * x[i]) >= reqProtein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= reqCarbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= reqCalories;

constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);

% Objective
solve minimize totalCost;
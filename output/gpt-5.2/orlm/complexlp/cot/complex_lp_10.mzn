% Parameters (with values embedded)
int: nFoods = 5;
set of int: FOODS = 1..nFoods;

array[FOODS] of string: foodName = ["Steak","Rice","Chicken","IcebergLettuce","Almonds"];

array[FOODS] of int: protein = [20, 6, 17, 1, 10];
array[FOODS] of int: carbs   = [12, 29, 26, 8, 2];
array[FOODS] of int: calories= [167,275,112,148,286];
array[FOODS] of int: cost    = [7,  8,  2,  8,  2];

int: reqProtein  = 83;
int: reqCarbs    = 128;
int: reqCalories = 1686;

% Variables
array[FOODS] of var 0..20: x;  % servings/units of each food (bounded for finiteness)

% Constraints
constraint sum(i in FOODS)(protein[i]  * x[i]) >= reqProtein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= reqCarbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= reqCalories;

% Objective
var int: totalCost = sum(i in FOODS)(cost[i] * x[i]);
solve minimize totalCost;
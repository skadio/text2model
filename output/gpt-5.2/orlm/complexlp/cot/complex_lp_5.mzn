% Parameters (with values embedded)
int: N = 9;
set of int: FOODS = 1..N;

array[FOODS] of string: food_name = ["Chicken","Rice","Apples","Steak","Lentils","Fish","Tofu","Cheese","Bread"];

array[FOODS] of int: protein = [15, 1, 1, 6, 3, 17, 18, 12, 2];
array[FOODS] of int: carbs   = [18,25,21, 3, 7, 13, 27, 17,30];
array[FOODS] of int: calories= [300,267,266,119,166,129,216, 76,258];
array[FOODS] of int: cost    = [  4,  2,  5, 10,  2,  8, 10,  9,  4];

int: minProtein  = 90;
int: minCarbs    = 105;
int: minCalories = 1805;

% Variables
array[FOODS] of var 0..100: x; % servings of each food (integer)
var int: totalCost = sum(i in FOODS)(cost[i] * x[i]);

% Constraints
constraint sum(i in FOODS)(protein[i]  * x[i]) >= minProtein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= minCarbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= minCalories;

% Objective
solve minimize totalCost;

output [show(totalCost)];
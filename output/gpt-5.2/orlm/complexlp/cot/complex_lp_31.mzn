% Parameters (with values embedded)
int: N = 6;
set of int: FOODS = 1..N;

array[FOODS] of string: name = ["Chicken","Rice","Lentils","Apples","Eggs","Broccoli"];

array[FOODS] of int: protein = [20, 2, 10, 5, 17, 6];
array[FOODS] of int: carbs   = [ 9,15, 30,19, 12,18];
array[FOODS] of int: calories= [89,276,255,258,212,246];
array[FOODS] of int: cost    = [ 6, 8,  4, 1,  3, 5];

int: minProtein  = 90;
int: minCarbs    = 162;
int: minCalories = 1926;

% Variables
array[FOODS] of var 0..100: x; % servings of each food (integer)
var int: totalCost = sum(i in FOODS)(cost[i] * x[i]);

% Constraints
constraint sum(i in FOODS)(protein[i] * x[i]) >= minProtein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= minCarbs;
constraint sum(i in FOODS)(calories[i]* x[i]) >= minCalories;

% Objective
solve minimize totalCost;

output [show(totalCost)];
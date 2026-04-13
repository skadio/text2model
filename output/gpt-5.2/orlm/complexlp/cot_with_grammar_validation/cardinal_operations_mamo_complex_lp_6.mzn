% Parameters
int: N = 5;
set of int: FOODS = 1..N;

array[FOODS] of int: protein = [10, 3, 17, 6, 20];
array[FOODS] of int: carbs   = [22, 4, 10, 13, 5];
array[FOODS] of int: calories= [80, 189, 153, 232, 204];
array[FOODS] of int: cost    = [2, 8, 4, 1, 8];

int: minProtein = 74;
int: minCarbs   = 102;
int: minCalories= 1564;

% Variables
var 0..20: maxServings; % auxiliary for bounds
constraint maxServings = 20;

array[FOODS] of var 0..20: x;

var 0..10000: totalCost;

% Constraints
constraint sum(i in FOODS)(protein[i] * x[i]) >= minProtein;
constraint sum(i in FOODS)(carbs[i] * x[i])   >= minCarbs;
constraint sum(i in FOODS)(calories[i] * x[i])>= minCalories;

constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);

% Objective
solve minimize totalCost;
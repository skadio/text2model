include "globals.mzn";

% Foods: 1=Chicken, 2=Rice, 3=Lentils, 4=Apples, 5=Eggs, 6=Broccoli
int: nFoods = 6;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [20, 2, 10, 5, 17, 6];
array[FOODS] of int: carbs   = [ 9,15, 30,19, 12,18];
array[FOODS] of int: calories= [89,276,255,258,212,246];
array[FOODS] of int: cost    = [ 6, 8,  4, 1,  3, 5];

int: reqProtein = 90;
int: reqCarbs   = 162;
int: reqCalories= 1926;

% Decision variables: number of servings of each food (nonnegative integers)
% Upper bound chosen safely: if you only ate the best calorie food (Rice, 276),
% you'd need at most ceil(1926/276)=7 servings; 30 is a generous safe bound.
int: UB = 30;
array[FOODS] of var 0..UB: x;

% Nutritional requirements
constraint sum(i in FOODS)(protein[i] * x[i]) >= reqProtein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= reqCarbs;
constraint sum(i in FOODS)(calories[i]* x[i]) >= reqCalories;

% Objective: minimize total cost
var int: totalCost = sum(i in FOODS)(cost[i] * x[i]);
solve minimize totalCost;

output [ show(totalCost) ];
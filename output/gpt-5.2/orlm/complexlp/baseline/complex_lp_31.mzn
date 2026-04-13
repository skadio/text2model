% Diet optimization problem: minimize cost while meeting nutrition requirements

set of int: FOODS = 1..6;
array[FOODS] of string: name = ["Chicken","Rice","Lentils","Apples","Eggs","Broccoli"];

array[FOODS] of int: protein = [20, 2, 10, 5, 17, 6];
array[FOODS] of int: carbs   = [ 9,15, 30,19, 12,18];
array[FOODS] of int: calories= [89,276,255,258,212,246];
array[FOODS] of int: cost    = [ 6, 8, 4, 1, 3, 5];

int: minProtein = 90;
int: minCarbs   = 162;
int: minCalories= 1926;

% Decision variables: number of servings of each food (nonnegative integers)
array[FOODS] of var 0..1000: x;

constraint sum(i in FOODS)(protein[i] * x[i]) >= minProtein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= minCarbs;
constraint sum(i in FOODS)(calories[i]* x[i]) >= minCalories;

var int: totalCost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize totalCost;

output [show(totalCost)];
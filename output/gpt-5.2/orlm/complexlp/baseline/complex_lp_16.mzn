% Meal planning / diet problem: minimize cost while meeting nutrition minimums
% All data embedded.

int: nFoods = 4;
set of int: FOODS = 1..nFoods;

array[FOODS] of string: name = ["Chicken","Broccoli","Beef","Rice"];

array[FOODS] of int: protein = [10, 4, 13, 15];
array[FOODS] of int: carbs   = [17, 3,  8, 25];
array[FOODS] of int: calories= [159,126,230,112];
array[FOODS] of int: cost    = [5,  5,  8,  3];

int: minProtein  = 66;
int: minCarbs    = 101;
int: minCalories = 1701;

% Decision variables: number of servings of each food (nonnegative integers)
array[FOODS] of var 0..200: x;

constraint sum(i in FOODS)(protein[i] * x[i])  >= minProtein;
constraint sum(i in FOODS)(carbs[i]   * x[i])  >= minCarbs;
constraint sum(i in FOODS)(calories[i]* x[i])  >= minCalories;

var int: totalCost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize totalCost;

output [show(totalCost)];
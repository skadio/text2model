% Diet optimization: minimize cost while meeting minimum nutrition targets.
% All data embedded in the model.

set of int: FOODS = 1..6;
array[FOODS] of string: name = ["Eggs","Chicken","Tofu","Salmon","Brown Rice","Spinach"];

array[FOODS] of int: protein = [1, 4, 13, 8, 7, 8];
array[FOODS] of int: carbs   = [13,10,  9, 3, 13,16];
array[FOODS] of int: calories= [211,256,273,54, 93, 52];
array[FOODS] of int: cost    = [10, 9,  2,10,  8,  1];

int: minProtein  = 60;
int: minCarbs    = 122;
int: minCalories = 2028;

% Decision variables: number of servings/units of each food item (nonnegative integers)
array[FOODS] of var 0..10000: x;

constraint sum(i in FOODS)(protein[i] * x[i])  >= minProtein;
constraint sum(i in FOODS)(carbs[i]   * x[i])  >= minCarbs;
constraint sum(i in FOODS)(calories[i]* x[i])  >= minCalories;

var int: totalCost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize totalCost;

output [
  "Minimum cost: $", show(totalCost), "\n",
  "Plan (servings):\n"
] ++
[ name[i] ++ ": " ++ show(x[i]) ++ "\n" | i in FOODS ] ++
[
  "\nTotals:\n",
  "Protein:  " ++ show(sum(i in FOODS)(protein[i]*x[i])) ++ "\n",
  "Carbs:    " ++ show(sum(i in FOODS)(carbs[i]*x[i])) ++ "\n",
  "Calories: " ++ show(sum(i in FOODS)(calories[i]*x[i])) ++ "\n"
];
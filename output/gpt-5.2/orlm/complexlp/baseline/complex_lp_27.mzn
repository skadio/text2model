% Diet optimization: minimize cost while meeting nutrient minimums

set of int: FOODS = 1..4;
array[FOODS] of string: food = ["Chicken","Rice","Broccoli","Eggs"];

array[FOODS] of int: protein = [17, 20, 3, 18];
array[FOODS] of int: carbs   = [6, 13, 25, 20];
array[FOODS] of int: calories= [94, 74, 73, 119];
array[FOODS] of int: cost    = [7, 10, 9, 2];

int: minProtein = 84;
int: minCarbs   = 117;
int: minCalories= 1554;

% Decision variables: number of servings of each food (nonnegative integers)
array[FOODS] of var 0..1000: x;

constraint sum(i in FOODS)(protein[i] * x[i]) >= minProtein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= minCarbs;
constraint sum(i in FOODS)(calories[i]* x[i]) >= minCalories;

var int: totalCost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize totalCost;

output [
  "Optimal minimal cost = ", show(totalCost), "\n",
  "Servings:\n",
  concat([food[i] ++ ": " ++ show(x[i]) ++ "\n" | i in FOODS]),
  "Totals:\n",
  "Protein: " ++ show(sum(i in FOODS)(protein[i]*x[i])) ++ "\n",
  "Carbs: " ++ show(sum(i in FOODS)(carbs[i]*x[i])) ++ "\n",
  "Calories: " ++ show(sum(i in FOODS)(calories[i]*x[i])) ++ "\n"
];
% Diet problem: minimize cost while meeting minimum nutrition targets.
% All data embedded directly in this model.

int: n = 9;
set of int: FOODS = 1..n;

array[FOODS] of string: name = [
  "Chicken Breast",
  "Tofu",
  "Brown Rice",
  "Salmon",
  "Greek Yogurt",
  "Steak",
  "Avocado",
  "Eggs",
  "Quinoa"
];

array[FOODS] of int: cost = [3, 2, 2, 6, 6, 10, 7, 5, 2];
array[FOODS] of int: protein = [17, 15, 1, 11, 15, 12, 4, 16, 11];
array[FOODS] of int: carbs   = [28, 11, 11, 3, 27, 3, 8, 25, 20];
array[FOODS] of int: calories= [136, 198, 93, 269, 121, 80, 300, 99, 87];

int: minProtein = 72;
int: minCarbs = 158;
int: minCalories = 1896;

% Decision variables: number of servings of each food item (nonnegative integers).
% A safe upper bound: at most minCalories servings if each serving adds at least 1 calorie.
array[FOODS] of var 0..minCalories: x;

constraint sum(i in FOODS)(protein[i] * x[i]) >= minProtein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= minCarbs;
constraint sum(i in FOODS)(calories[i]* x[i]) >= minCalories;

var int: totalCost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize totalCost;

output [
  "Minimum cost = $", show(totalCost), "\n",
  "Servings:\n"
] ++
[
  name[i] ++ ": " ++ show(x[i]) ++ "\n"
  | i in FOODS
] ++
[
  "\nTotals:\n",
  "Protein: " ++ show(sum(i in FOODS)(protein[i]*x[i])) ++ "\n",
  "Carbs: " ++ show(sum(i in FOODS)(carbs[i]*x[i])) ++ "\n",
  "Calories: " ++ show(sum(i in FOODS)(calories[i]*x[i])) ++ "\n"
];
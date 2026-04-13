% Diet / meal plan optimization (all data embedded)

set of int: FOODS = 1..6;
array[FOODS] of string: name = ["Chicken","Rice","Eggs","Broccoli","Lentils","Apples"];

array[FOODS] of int: protein = [18,14,18,7,15,8];
array[FOODS] of int: carbs   = [5,13,4,15,17,13];
array[FOODS] of int: calories= [202,234,220,247,88,77];
array[FOODS] of int: cost    = [1,7,4,3,1,2];

int: min_protein  = 70;
int: min_carbs    = 187;
int: min_calories = 2181;

% Decision variables: number of servings of each food (nonnegative integers)
array[FOODS] of var 0..1000: x;

var int: total_cost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i]) >= min_protein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= min_carbs;
constraint sum(i in FOODS)(calories[i]* x[i]) >= min_calories;

solve minimize total_cost;

output [
  "Minimum total cost = $", show(total_cost), "\n",
  "Servings:\n"
] ++
[
  name[i] ++ ": " ++ show(x[i]) ++ "\n" | i in FOODS
] ++
[
  "Totals:\n",
  "Protein: " ++ show(sum(i in FOODS)(protein[i]*x[i])) ++ " g\n",
  "Carbs: " ++ show(sum(i in FOODS)(carbs[i]*x[i])) ++ " g\n",
  "Calories: " ++ show(sum(i in FOODS)(calories[i]*x[i])) ++ " kcal\n"
];
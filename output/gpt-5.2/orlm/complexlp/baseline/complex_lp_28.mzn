% Diet optimization problem: minimize cost while meeting nutrition requirements
% All data embedded in the model.

set of int: FOODS = 1..9;
array[FOODS] of string: food_name =
  ["Beef","Pasta","Broccoli","Chicken","Apple","Pork","Lentils","Eggs","Cheese"];

array[FOODS] of int: cost     = [5,6,5,4,1,6,1,2,7];
array[FOODS] of int: protein  = [18,2,7,20,5,13,15,20,9];
array[FOODS] of int: carbs    = [13,25,30,16,6,9,18,18,14];
array[FOODS] of int: calories = [233,251,191,231,111,275,99,210,74];

int: req_protein  = 68;
int: req_carbs    = 151;
int: req_calories = 1900;

% Decision variables: number of servings of each food item (nonnegative integers)
% Upper bound chosen large enough to allow feasibility.
array[FOODS] of var 0..200: x;

var int: total_cost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i]  * x[i]) >= req_protein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= req_carbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= req_calories;

solve minimize total_cost;

output [
  "Minimum cost = $", show(total_cost), "\n",
  "Servings:\n"
] ++
[
  food_name[i] ++ ": " ++ show(x[i]) ++ "\n"
  | i in FOODS
] ++
[
  "\nTotals:\n",
  "Protein  = ", show(sum(i in FOODS)(protein[i]  * x[i])), " g\n",
  "Carbs    = ", show(sum(i in FOODS)(carbs[i]    * x[i])), " g\n",
  "Calories = ", show(sum(i in FOODS)(calories[i] * x[i])), " kcal\n"
];
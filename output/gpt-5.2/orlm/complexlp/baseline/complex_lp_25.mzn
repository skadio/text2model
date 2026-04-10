% Diet problem: minimize cost while meeting minimum nutrition targets

set of int: FOODS = 1..6;
array[FOODS] of string: name = ["Chicken","Rice","Tuna","Beef","Corn","Whey"];

array[FOODS] of int: protein = [13, 1, 17, 15, 2, 15];
array[FOODS] of int: carbs   = [27, 1,  2, 18,19, 11];
array[FOODS] of int: calories= [81,137,53,126,117,277];
array[FOODS] of int: cost    = [1,  9,  2,  9,  4,  6];

int: min_protein  = 58;
int: min_carbs    = 148;
int: min_calories = 2454;

% Decision variables: number of servings of each food (nonnegative integers)
array[FOODS] of var 0..500: x;

constraint sum(i in FOODS)(protein[i] * x[i])  >= min_protein;
constraint sum(i in FOODS)(carbs[i]   * x[i])  >= min_carbs;
constraint sum(i in FOODS)(calories[i]* x[i])  >= min_calories;

var int: total_cost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize total_cost;

output [
  "Total cost = $", show(total_cost), "\n",
  "Servings:\n"
] ++
[
  name[i] ++ ": " ++ show(x[i]) ++ "\n" | i in FOODS
] ++
[
  "\nTotals:\n",
  "Protein  = ", show(sum(i in FOODS)(protein[i]*x[i])), " g\n",
  "Carbs    = ", show(sum(i in FOODS)(carbs[i]*x[i])), " g\n",
  "Calories = ", show(sum(i in FOODS)(calories[i]*x[i])), " kcal\n"
];
% Diet planning / cheapest meal meeting nutrient minimums

int: nFoods = 4;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [2, 11, 19, 17];
array[FOODS] of int: carbs   = [9, 29, 16, 9];
array[FOODS] of int: calories= [165, 230, 68, 258];
array[FOODS] of int: cost    = [3, 3, 6, 9];

int: minProtein = 88;
int: minCarbs   = 107;
int: minCalories= 1944;

% Upper bounds sufficient to meet each minimum using the best single food for that nutrient
int: maxCount = max([
  (minProtein + min(protein) - 1) div min(protein),
  (minCarbs + min(carbs) - 1) div min(carbs),
  (minCalories + min(calories) - 1) div min(calories)
]);

array[FOODS] of var 0..maxCount: x;  % number of servings of each food

constraint sum(i in FOODS)(protein[i] * x[i]) >= minProtein;
constraint sum(i in FOODS)(carbs[i] * x[i])   >= minCarbs;
constraint sum(i in FOODS)(calories[i] * x[i])>= minCalories;

var int: total_cost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize total_cost;

output [
  "servings = ", show(x), "\n",
  "total_cost = ", show(total_cost), "\n",
  "total_protein = ", show(sum(i in FOODS)(protein[i] * x[i])), "\n",
  "total_carbs = ", show(sum(i in FOODS)(carbs[i] * x[i])), "\n",
  "total_calories = ", show(sum(i in FOODS)(calories[i] * x[i])), "\n"
];
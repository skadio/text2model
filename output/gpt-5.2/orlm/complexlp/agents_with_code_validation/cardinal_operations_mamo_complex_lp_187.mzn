% Diet problem: minimize cost while meeting minimum nutrition requirements

int: n_foods = 4;
set of int: FOODS = 1..n_foods;

array[FOODS] of string: food_name = ["Bread", "Milk", "Fish", "Potato"];

array[FOODS] of int: protein_g = [4, 6, 20, 1];
array[FOODS] of int: carbs_g   = [7, 10, 0, 30];
array[FOODS] of int: calories  = [130, 120, 150, 70];
array[FOODS] of int: cost_dol  = [3, 4, 8, 2];

int: min_protein_g = 30;
int: min_carbs_g   = 40;
int: min_calories  = 400;

% Safe upper bound on servings for each food.
% Use large/benign bound for any division by zero case (protein==0 or carbs==0).
array[FOODS] of int: max_servings =
[
  max([
    if protein_g[i] > 0 then (min_protein_g + protein_g[i] - 1) div protein_g[i] else 0 endif,
    if carbs_g[i]   > 0 then (min_carbs_g   + carbs_g[i]   - 1) div carbs_g[i]   else 0 endif,
    if calories[i]  > 0 then (min_calories  + calories[i]  - 1) div calories[i]  else 0 endif
  ])
  | i in FOODS
];

array[FOODS] of var int: servings;
constraint forall(i in FOODS)(servings[i] >= 0 /\ servings[i] <= max_servings[i]);

var int: total_cost;
constraint total_cost = sum(i in FOODS)(servings[i] * cost_dol[i]);

constraint sum(i in FOODS)(servings[i] * protein_g[i]) >= min_protein_g;
constraint sum(i in FOODS)(servings[i] * carbs_g[i])   >= min_carbs_g;
constraint sum(i in FOODS)(servings[i] * calories[i])  >= min_calories;

solve minimize total_cost;

output [
  "Total cost ($): ", show(total_cost), "\n"
] ++
[
  food_name[i] ++ ": " ++ show(servings[i]) ++ "\n"
  | i in FOODS
];
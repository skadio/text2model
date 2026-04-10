% Parameters
int: N = 5;
set of int: FOODS = 1..N;

array[FOODS] of int: protein = [10, 3, 17, 6, 20];
array[FOODS] of int: carbs   = [22, 4, 10, 13, 5];
array[FOODS] of int: calories= [80, 189, 153, 232, 204];
array[FOODS] of int: cost    = [2, 8, 4, 1, 8];

int: min_protein  = 74;
int: min_carbs    = 102;
int: min_calories = 1564;

% Variables
int: max_units =
  max([ (min_protein div protein[i]) + 1 | i in FOODS where protein[i] > 0 ] ++
      [ (min_carbs div carbs[i]) + 1     | i in FOODS where carbs[i] > 0 ] ++
      [ (min_calories div calories[i]) + 1 | i in FOODS where calories[i] > 0 ]);

array[FOODS] of var 0..max_units: x;

var 0..(max_units * sum(cost)): total_cost;

% Constraints
constraint sum(i in FOODS)(protein[i] * x[i]) >= min_protein;
constraint sum(i in FOODS)(carbs[i] * x[i])   >= min_carbs;
constraint sum(i in FOODS)(calories[i] * x[i])>= min_calories;

constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

% Objective
solve minimize total_cost;
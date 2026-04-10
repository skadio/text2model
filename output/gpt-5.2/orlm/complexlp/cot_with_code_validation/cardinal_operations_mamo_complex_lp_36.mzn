% Parameters
int: nFoods = 4;
set of int: FOODS = 1..nFoods;

% Nutrients: 1=protein, 2=carbs, 3=calories
int: nNutrients = 3;
set of int: NUTS = 1..nNutrients;

array[FOODS] of int: cost = [4, 1, 9, 4];

array[NUTS, FOODS] of int: nutr = array2d(NUTS, FOODS, [
  20,  7,  1, 10,   % protein
   2,  3, 26,  1,   % carbs
  68, 143, 52, 69   % calories
]);

array[NUTS] of int: req = [71, 141, 1839];

% Variables
array[FOODS] of var 0..1000: x;
var 0..100000: total_cost;

% Constraints
constraint forall(n in NUTS)(
  sum(f in FOODS)(nutr[n,f] * x[f]) >= req[n]
);

constraint total_cost = sum(f in FOODS)(cost[f] * x[f]);

% Objective
solve minimize total_cost;
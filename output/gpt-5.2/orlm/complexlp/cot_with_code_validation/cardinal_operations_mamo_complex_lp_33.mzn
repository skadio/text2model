% Parameters
int: N = 5;
set of int: FOODS = 1..N;

array[FOODS] of int: protein  = [12, 12, 19, 19, 4];
array[FOODS] of int: carbs    = [2, 24, 18, 7, 27];
array[FOODS] of int: calories = [186, 250, 134, 84, 104];
array[FOODS] of int: cost     = [6, 6, 6, 7, 9];

int: minProtein  = 97;
int: minCarbs    = 163;
int: minCalories = 2217;

int: maxCost = max(cost);
int: maxUnitsByCalories = minCalories div min(calories) + 1;
int: maxUnitsByNutrients =
  max(maxUnitsByCalories,
      max(minProtein div min(protein) + 1, minCarbs div min(carbs) + 1));
int: maxUnits = maxUnitsByNutrients;

% Variables
array[FOODS] of var 0..maxUnits: x;
var 0..(maxUnits * maxCost * N): totalCost;

% Constraints
constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i])  >= minProtein;
constraint sum(i in FOODS)(carbs[i] * x[i])    >= minCarbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= minCalories;

% Objective (minimum cost)
solve minimize totalCost;
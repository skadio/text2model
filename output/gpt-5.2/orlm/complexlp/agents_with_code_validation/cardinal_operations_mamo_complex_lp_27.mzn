% Parameters
% Food items (fixed in-model as per problem statement)
int: nFoods = 4;
set of int: FOODS = 1..nFoods;

% Nutrient types: 1=protein, 2=carbohydrates, 3=calories
int: nNutrients = 3;
set of int: NUTRIENTS = 1..nNutrients;

% Cost per unit of each food: [Chicken, Rice, Broccoli, Eggs]
array[FOODS] of int: cost = [7, 10, 9, 2];

% Nutrient contribution per unit of each food (rows=foods, cols=nutrients)
% Chicken:  [17,  6,  94]
% Rice:     [20, 13,  74]
% Broccoli: [ 3, 25,  73]
% Eggs:     [18, 20, 119]
array[FOODS, NUTRIENTS] of int: nutrient =
  [| 17,  6,  94
   | 20, 13,  74
   |  3, 25,  73
   | 18, 20, 119
  |];

% Minimum required intake for each nutrient: [protein, carbohydrates, calories]
array[NUTRIENTS] of int: minReq = [84, 117, 1554];

% Upper bounds for servings (kept finite for bounded search; safe large caps)
int: maxServingsPerFood = 1000;


% Variables
% Integer number of servings (units) chosen for each food (non-negative)
array[FOODS] of var 0..maxServingsPerFood: servings;

% Total cost (bounded)
var 0..(maxServingsPerFood * sum(f in FOODS)(cost[f])): totalCost;

% Total intake per nutrient (bounded)
array[NUTRIENTS] of var 0..(maxServingsPerFood * sum(f in FOODS)(nutrient[f, 3])): totalNutrient;


% Constraints
% Link total nutrient intake to chosen servings for each nutrient type
constraint
  forall(n in NUTRIENTS)(
    totalNutrient[n] = sum(f in FOODS)(servings[f] * nutrient[f, n])
  );

% Enforce minimum dietary requirements for each nutrient
constraint
  forall(n in NUTRIENTS)(
    totalNutrient[n] >= minReq[n]
  );

% Link total cost to chosen servings and per-food costs
constraint
  totalCost = sum(f in FOODS)(servings[f] * cost[f]);


% Objective
solve minimize totalCost;
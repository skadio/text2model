% Parameters
% Food items
int: nFoods = 4;
set of int: FOODS = 1..nFoods;

% Nutrients (protein, carbs, calories)
int: nNutrients = 3;
set of int: NUTRIENTS = 1..nNutrients;

% Indices for readability
int: PROTEIN = 1;
int: CARBS   = 2;
int: CALS    = 3;

% Cost per unit of each food (Eggs, Rice, Chicken, Broccoli)
array[FOODS] of int: cost = [6, 10, 1, 7];

% Nutrient content per unit of each food:
% rows = foods (Eggs, Rice, Chicken, Broccoli)
% cols = nutrients (Protein, Carbs, Calories)
array[FOODS, NUTRIENTS] of int: nutrient =
  [|  4, 13, 238  % Eggs
   |  1, 13,  85  % Rice
   | 10, 29, 146  % Chicken
   |  8, 26, 139  % Broccoli
  |];

% Minimum daily requirements for (Protein, Carbs, Calories)
array[NUTRIENTS] of int: req = [93, 165, 1553];

% A safe upper bound on servings (conservative and valid upper bound)
int: maxServings = 1553;

% Variables
% Number of servings/units chosen of each food
array[FOODS] of var 0..maxServings: servings;

% Total cost
var 0..(maxServings * sum(f in FOODS)(cost[f])): totalCost;

% Total nutrient intake for each nutrient
% Upper bound: maxServings * sum of nutrient values for that nutrient across foods
array[NUTRIENTS] of var 0..(maxServings * max(n in NUTRIENTS)(sum(f in FOODS)(nutrient[f, n]))): totalNutrient;

% Constraints
% Link total cost to chosen servings
constraint
  totalCost = sum(f in FOODS)(cost[f] * servings[f]);

% Link total nutrient intake variables to chosen servings
constraint
  forall(n in NUTRIENTS) (
    totalNutrient[n] = sum(f in FOODS)(nutrient[f, n] * servings[f])
  );

% Enforce minimum daily nutrient requirements
constraint
  forall(n in NUTRIENTS) (
    totalNutrient[n] >= req[n]
  );

% Objective
solve minimize totalCost;
% Parameters
int: nFoods = 9;                              % number of available food items
set of int: FOODS = 1..nFoods;                % index set for foods

array[FOODS] of int: cost =                   % cost per unit of each food ($)
  [3, 2, 2, 6, 6, 10, 7, 5, 2];

array[FOODS] of int: protein =                % protein per unit (grams)
  [17, 15, 1, 11, 15, 12, 4, 16, 11];

array[FOODS] of int: carbs =                  % carbohydrates per unit (grams)
  [28, 11, 11, 3, 27, 3, 8, 25, 20];

array[FOODS] of int: calories =               % calories per unit
  [136, 198, 93, 269, 121, 80, 300, 99, 87];

int: minProtein = 72;                         % minimum required protein
int: minCarbs   = 158;                        % minimum required carbohydrates
int: minCalories = 1896;                      % minimum required calories

% Safe upper bound for number of units of any single food (enough to reach calorie target alone)
int: maxUnits = max([ (minCalories + calories[i] - 1) div calories[i] | i in FOODS ]);

% Variables
array[FOODS] of var 0..maxUnits: x;               % number of units chosen of each food

var 0..(maxUnits * sum(cost)): totalCost;         % total cost to minimize
var 0..(maxUnits * sum(protein)): totalProtein;   % total protein achieved
var 0..(maxUnits * sum(carbs)): totalCarbs;       % total carbs achieved
var 0..(maxUnits * sum(calories)): totalCalories; % total calories achieved

% Constraints

% --- Link decision variables to total nutrient and cost aggregates ---
constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);
constraint totalProtein = sum(i in FOODS)(protein[i] * x[i]);
constraint totalCarbs = sum(i in FOODS)(carbs[i] * x[i]);
constraint totalCalories = sum(i in FOODS)(calories[i] * x[i]);

% --- Minimum nutrition requirements must be met (or exceeded) ---
constraint totalProtein >= minProtein;
constraint totalCarbs >= minCarbs;
constraint totalCalories >= minCalories;

% Objective
solve minimize totalCost;
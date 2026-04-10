% Parameters
int: nFoods = 5;                                  % number of food items
set of int: FOODS = 1..nFoods;                    % index set for foods

array[FOODS] of string: foodName =                % names of foods (for readability)
  ["Lentils", "Rice", "Chicken", "Beef", "Tofu"];

array[FOODS] of int: cost =                       % dollars per unit/serving
  [7, 6, 6, 10, 2];

array[FOODS] of int: protein =                    % grams of protein per unit
  [13, 2, 7, 18, 12];

array[FOODS] of int: carbs =                      % grams of carbohydrates per unit
  [21, 30, 13, 8, 28];

array[FOODS] of int: calories =                   % calories per unit
  [284, 55, 276, 204, 160];

int: minProtein = 79;                             % required minimum protein
int: minCarbs = 170;                              % required minimum carbs
int: minCalories = 1699;                          % required minimum calories

% A safe finite upper bound on each food quantity (used for variable domains)
int: maxReq = max(minProtein, max(minCarbs, minCalories));
int: ubQty = ceil(int2float(maxReq));             % equals maxReq, kept explicit/safe

% Variables
array[FOODS] of var 0..ubQty: x;                  % units of each food to buy (nonnegative integer)

var 0..(max(cost) * nFoods * ubQty): totalCost;   % total spending in dollars (simple safe bound)

% Constraints
% Link totalCost to chosen quantities and per-food costs
constraint
  totalCost = sum(i in FOODS)(cost[i] * x[i]);

% Meet minimum protein requirement
constraint
  sum(i in FOODS)(protein[i] * x[i]) >= minProtein;

% Meet minimum carbohydrate requirement
constraint
  sum(i in FOODS)(carbs[i] * x[i]) >= minCarbs;

% Meet minimum calorie requirement
constraint
  sum(i in FOODS)(calories[i] * x[i]) >= minCalories;

% Objective
solve minimize totalCost;
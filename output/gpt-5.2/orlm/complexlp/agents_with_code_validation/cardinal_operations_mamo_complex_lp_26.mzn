% Parameters
int: nFoods = 8;                                % Number of food items
set of int: FOODS = 1..nFoods;                  % Index set for foods

array[FOODS] of string: foodName =              % Food names (for readability)
  ["Chicken","Rice","Eggs","Beans","Spinach","Corn","Beef","Broccoli"];

array[FOODS] of int: protein =                  % Protein per unit of each food (g)
  [5, 8, 18, 16, 3, 3, 6, 17];

array[FOODS] of int: carbs =                    % Carbohydrates per unit of each food (g)
  [15, 17, 20, 15, 28, 19, 24, 9];

array[FOODS] of int: calories =                 % Calories per unit of each food
  [162, 282, 234, 85, 194, 153, 167, 192];

array[FOODS] of int: cost =                     % Cost per unit of each food ($)
  [8, 4, 1, 4, 7, 2, 9, 3];

int: minProtein = 68;                           % Minimum total protein required (g)
int: minCarbs = 189;                            % Minimum total carbs required (g)
int: minCalories = 1840;                        % Minimum total calories required


% Variables
array[FOODS] of var 0..50: qty;                 % Quantity chosen of each food (nonnegative integer)
var 0..100000: totalCost;                       % Total cost (bounded for safety)


% Constraints
% Link totalCost to chosen quantities and per-unit costs
constraint
  totalCost = sum(f in FOODS)(qty[f] * cost[f]);

% Minimum protein requirement
constraint
  sum(f in FOODS)(qty[f] * protein[f]) >= minProtein;

% Minimum carbohydrate requirement
constraint
  sum(f in FOODS)(qty[f] * carbs[f]) >= minCarbs;

% Minimum calorie requirement
constraint
  sum(f in FOODS)(qty[f] * calories[f]) >= minCalories;


% Objective
solve minimize totalCost;
% Parameters
int: nFoods = 5;                                  % number of food items
set of int: FOODS = 1..nFoods;                    % index set for foods

array[FOODS] of string: foodName =
  ["Steak", "Apples", "Eggs", "Chicken", "Tofu"]; % food names (for readability/output)

array[FOODS] of int: cost =
  [6, 1, 1, 3, 1];                                % cost per unit serving

array[FOODS] of int: protein =
  [1, 7, 6, 20, 8];                               % grams of protein per serving

array[FOODS] of int: carbs =
  [3, 22, 18, 6, 4];                              % grams of carbohydrates per serving

array[FOODS] of int: calories =
  [210, 96, 189, 132, 75];                        % calories per serving

int: minProtein = 87;                             % minimum required protein
int: minCarbs   = 135;                            % minimum required carbohydrates
int: minCalories = 1926;                          % minimum required calories

% Useful upper bounds for servings (safe, derived from requirements and per-serving nutrients)
% If a food has 0 contribution to a nutrient, use a generous cap; none are 0 here.
int: ubProtein = max([ceil(int2float(minProtein) / int2float(protein[i])) | i in FOODS]);
int: ubCarbs   = max([ceil(int2float(minCarbs)   / int2float(carbs[i]))   | i in FOODS]);
int: ubCalories= max([ceil(int2float(minCalories)/ int2float(calories[i]))| i in FOODS]);
int: maxServings = max([ubProtein, ubCarbs, ubCalories]); % global cap to bound decision vars

% Variables
array[FOODS] of var 0..maxServings: servings;     % number of servings of each food (nonnegative integer)
var int: totalCost;                               % total cost to minimize
var int: totalProtein;                            % total protein achieved
var int: totalCarbs;                              % total carbohydrates achieved
var int: totalCalories;                           % total calories achieved

% Constraints

% Compute total nutrient and cost totals from chosen servings
constraint totalCost =
  sum(i in FOODS)(cost[i] * servings[i]);

constraint totalProtein =
  sum(i in FOODS)(protein[i] * servings[i]);

constraint totalCarbs =
  sum(i in FOODS)(carbs[i] * servings[i]);

constraint totalCalories =
  sum(i in FOODS)(calories[i] * servings[i]);

% Enforce minimum dietary requirements
constraint totalProtein  >= minProtein;
constraint totalCarbs    >= minCarbs;
constraint totalCalories >= minCalories;

% Objective
solve minimize totalCost;
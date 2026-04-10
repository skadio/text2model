% Parameters
int: nFoods = 9;                                  % Number of available food items
set of int: FOODS = 1..nFoods;                    % Index set for foods

array[FOODS] of int: cost =
  [3, 2, 2, 6, 6, 10, 7, 5, 2];                    % Cost per unit of each food
array[FOODS] of int: protein =
  [17, 15, 1, 11, 15, 12, 4, 16, 11];              % Protein grams per unit
array[FOODS] of int: carbs =
  [28, 11, 11, 3, 27, 3, 8, 25, 20];               % Carbohydrates grams per unit
array[FOODS] of int: calories =
  [136, 198, 93, 269, 121, 80, 300, 99, 87];       % Calories per unit

int: minProtein = 72;                              % Minimum required protein
int: minCarbs = 158;                               % Minimum required carbohydrates
int: minCalories = 1896;                           % Minimum required calories

% Variables
array[FOODS] of var 0..14: x;                      % Units selected for each food (bounded)

var 0..(14 * sum(cost)): totalCost;                % Total cost to minimize
var 0..(14 * sum(protein)): totalProtein;          % Total protein achieved
var 0..(14 * sum(carbs)): totalCarbs;              % Total carbs achieved
var 0..(14 * sum(calories)): totalCalories;        % Total calories achieved

% Constraints
% Compute totals from chosen units
constraint totalCost = sum(f in FOODS)(cost[f] * x[f]);
constraint totalProtein = sum(f in FOODS)(protein[f] * x[f]);
constraint totalCarbs = sum(f in FOODS)(carbs[f] * x[f]);
constraint totalCalories = sum(f in FOODS)(calories[f] * x[f]);

% Enforce minimum nutritional requirements
constraint totalProtein >= minProtein;
constraint totalCarbs >= minCarbs;
constraint totalCalories >= minCalories;

% Objective
solve minimize totalCost;
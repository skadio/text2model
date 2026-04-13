% Parameters
int: nFoods = 4;                    % Number of food items
set of int: FOODS = 1..nFoods;      % Index set for foods

array[FOODS] of int: cost = [6, 10, 1, 7];            % Cost per unit of each food
array[FOODS] of int: protein = [4, 1, 10, 8];         % Protein (g) per unit
array[FOODS] of int: carbs = [13, 13, 29, 26];        % Carbohydrates (g) per unit
array[FOODS] of int: calories = [238, 85, 146, 139];  % Calories per unit

int: minProtein = 93;               % Minimum required protein (g)
int: minCarbs = 165;                % Minimum required carbohydrates (g)
int: minCalories = 1553;            % Minimum required calories

% Variables
array[FOODS] of var 0..10000: x;    % Units chosen of each food (nonnegative integer)

var 0..1000000: totalCost;          % Total cost (to be minimized)
var 0..1000000: totalProtein;       % Total protein achieved
var 0..1000000: totalCarbs;         % Total carbohydrates achieved
var 0..1000000: totalCalories;      % Total calories achieved

% Constraints
% --- Aggregate totals from chosen food units ---
constraint totalCost = sum(f in FOODS)(cost[f] * x[f]);
constraint totalProtein = sum(f in FOODS)(protein[f] * x[f]);
constraint totalCarbs = sum(f in FOODS)(carbs[f] * x[f]);
constraint totalCalories = sum(f in FOODS)(calories[f] * x[f]);

% --- Meet minimum daily nutrition requirements ---
constraint totalProtein >= minProtein;
constraint totalCarbs >= minCarbs;
constraint totalCalories >= minCalories;

% Objective
solve minimize totalCost;
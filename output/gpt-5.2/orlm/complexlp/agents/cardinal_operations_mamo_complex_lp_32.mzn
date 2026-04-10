% Parameters
int: nFoods = 6;                          % number of food items
set of int: FOODS = 1..nFoods;            % index set for foods

array[FOODS] of string: foodName =
  ["Pasta","Avocado","Chicken","Tofu","Spinach","Cheese"];  % food labels

array[FOODS] of int: protein = [15, 20, 15, 19, 19, 12];    % grams protein per unit
array[FOODS] of int: carbs   = [30, 16,  8,  5, 28, 17];    % grams carbs per unit
array[FOODS] of int: calories= [154,111,211, 87, 98,231];   % calories per unit
array[FOODS] of int: cost    = [  3,  8,  7,  2,  9, 10];   % cost per unit ($)

int: minProtein  = 73;     % required minimum protein
int: minCarbs    = 111;    % required minimum carbs
int: minCalories = 2196;   % required minimum calories

% Variables
array[FOODS] of var 0..30: qty;  % nonnegative integer quantity of each food (bounded)
var 0..10000: totalCost;         % total cost (bounded for linear objective)

% Constraints
% --- Total cost definition ---
constraint
  totalCost = sum(f in FOODS)(cost[f] * qty[f]);

% --- Minimum protein requirement ---
constraint
  sum(f in FOODS)(protein[f] * qty[f]) >= minProtein;

% --- Minimum carbohydrates requirement ---
constraint
  sum(f in FOODS)(carbs[f] * qty[f]) >= minCarbs;

% --- Minimum calories requirement ---
constraint
  sum(f in FOODS)(calories[f] * qty[f]) >= minCalories;

% Objective
solve minimize totalCost;
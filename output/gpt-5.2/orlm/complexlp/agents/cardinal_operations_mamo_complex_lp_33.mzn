% Parameters
int: nFoods = 5;                         % number of available food items
set of int: FOODS = 1..nFoods;           % index set for foods

array[FOODS] of string: foodName =       % names of foods (for readability)
  ["Chicken", "Rice", "Beans", "Broccoli", "Fruit"];

array[FOODS] of int: protein =           % grams of protein per unit of each food
  [12, 12, 19, 19, 4];

array[FOODS] of int: carbs =             % grams of carbohydrates per unit of each food
  [2, 24, 18, 7, 27];

array[FOODS] of int: calories =          % calories per unit of each food
  [186, 250, 134, 84, 104];

array[FOODS] of int: cost =              % cost ($) per unit of each food
  [6, 6, 6, 7, 9];

int: minProtein = 97;                    % minimum required protein
int: minCarbs = 163;                     % minimum required carbohydrates
int: minCalories = 2217;                 % minimum required calories

% Variables
array[FOODS] of var 0..100: qty;         % quantity (integer units) of each food chosen
var 0..100000: totalCost;                % total cost of selected foods
var 0..100000: totalProtein;             % total protein achieved
var 0..100000: totalCarbs;               % total carbohydrates achieved
var 0..100000: totalCalories;            % total calories achieved

% Constraints
% --- Aggregate nutrient and cost totals from chosen quantities ---
constraint
  totalCost = sum(f in FOODS)(cost[f] * qty[f]);

constraint
  totalProtein = sum(f in FOODS)(protein[f] * qty[f]);

constraint
  totalCarbs = sum(f in FOODS)(carbs[f] * qty[f]);

constraint
  totalCalories = sum(f in FOODS)(calories[f] * qty[f]);

% --- Meet minimum dietary requirements ---
constraint
  totalProtein >= minProtein;

constraint
  totalCarbs >= minCarbs;

constraint
  totalCalories >= minCalories;

% Objective
solve minimize totalCost;
% Parameters
int: nFoods = 6;                           % number of foods
set of int: FOODS = 1..nFoods;             % index set for foods

array[FOODS] of string: food_name =
  ["Chicken","Rice","Lentils","Apples","Eggs","Broccoli"];

array[FOODS] of int: protein = [20, 2, 10, 5, 17, 6];     % grams per unit
array[FOODS] of int: carbs   = [ 9,15, 30,19, 12,18];     % grams per unit
array[FOODS] of int: calories= [89,276,255,258,212,246];  % calories per unit
array[FOODS] of int: cost    = [ 6, 8,  4, 1,  3, 5];     % dollars per unit

int: minProtein  = 90;     % required minimum protein
int: minCarbs    = 162;    % required minimum carbs
int: minCalories = 1926;   % required minimum calories

% Variables
array[FOODS] of var 0..22: x;              % units of each food chosen (bounded)
var 0..1000: totalCost;                    % total cost (bounded)

% Constraints
% Total cost definition
constraint
  totalCost = sum(f in FOODS)(cost[f] * x[f]);

% Minimum protein requirement
constraint
  sum(f in FOODS)(protein[f] * x[f]) >= minProtein;

% Minimum carbohydrate requirement
constraint
  sum(f in FOODS)(carbs[f] * x[f]) >= minCarbs;

% Minimum calorie requirement
constraint
  sum(f in FOODS)(calories[f] * x[f]) >= minCalories;

% Objective
solve minimize totalCost;
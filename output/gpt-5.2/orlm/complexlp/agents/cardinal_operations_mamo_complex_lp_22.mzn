% Parameters
int: nFoods = 6;                          % number of available food items
set of int: FOODS = 1..nFoods;            % index set for foods

int: req_protein  = 88;                   % required grams of protein per day
int: req_carbs    = 144;                  % required grams of carbohydrates per day
int: req_calories = 1900;                 % required calories per day

array[FOODS] of int: protein  = [15, 16, 3, 19, 11, 10];    % grams protein per unit of each food
array[FOODS] of int: carbs    = [10, 25, 8, 20, 8, 9];      % grams carbs per unit of each food
array[FOODS] of int: calories = [163,108,198,141,105,199];  % calories per unit of each food
array[FOODS] of int: cost     = [10, 4, 1, 7, 6, 8];        % cost ($) per unit of each food

% A safe upper bound on units needed (from calories only, since all are positive)
int: maxUnits = req_calories div min(calories) + 1;

% Variables
array[FOODS] of var 0..maxUnits: units;    % integer number of units chosen for each food item

var int: total_cost;                       % total cost of the daily meal plan
var int: total_protein;                    % total protein provided
var int: total_carbs;                      % total carbohydrates provided
var int: total_calories;                   % total calories provided

% Constraints

% Link total nutrient and cost variables to chosen units (linear totals)
constraint total_protein  = sum(f in FOODS)(protein[f] * units[f]);
constraint total_carbs    = sum(f in FOODS)(carbs[f] * units[f]);
constraint total_calories = sum(f in FOODS)(calories[f] * units[f]);
constraint total_cost     = sum(f in FOODS)(cost[f] * units[f]);

% Meet (at least) the daily nutritional requirements
constraint total_protein  >= req_protein;
constraint total_carbs    >= req_carbs;
constraint total_calories >= req_calories;

% Objective
solve minimize total_cost;
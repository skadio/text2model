% Parameters
int: nFoods = 6;                         % number of available food items
set of int: FOODS = 1..nFoods;           % index set for foods

array[FOODS] of string: foodName =
  ["ChickenBreast", "BrownRice", "Tofu", "Spinach", "Almonds", "Salmon"];

array[FOODS] of int: cost =
  [4, 10, 6, 1, 8, 6];                   % cost per serving ($)

array[FOODS] of int: protein =
  [14, 11, 20, 6, 9, 20];                % grams protein per serving

array[FOODS] of int: carbs =
  [4, 17, 12, 20, 11, 19];               % grams carbs per serving

array[FOODS] of int: calories =
  [275, 151, 155, 106, 279, 93];         % calories per serving

int: reqProtein  = 78;                   % required grams of protein
int: reqCarbs    = 140;                  % required grams of carbs
int: reqCalories = 1537;                 % required calories

% Upper bounds for servings (safe, derived from requirements and positive nutrients)
% (Need only enough servings to possibly meet each requirement)
int: maxServings =
  max([
    (reqProtein  + min([protein[f]  | f in FOODS]) - 1) div min([protein[f]  | f in FOODS]),
    (reqCarbs    + min([carbs[f]    | f in FOODS]) - 1) div min([carbs[f]    | f in FOODS]),
    (reqCalories + min([calories[f] | f in FOODS]) - 1) div min([calories[f] | f in FOODS])
  ]);

% Variables
array[FOODS] of var 0..maxServings: servings;   % number of servings chosen for each food (integer)

var int: totalCost;                             % total cost to minimize
var int: totalProtein;                          % total protein achieved
var int: totalCarbs;                            % total carbs achieved
var int: totalCalories;                         % total calories achieved


% Constraints

% --- Total aggregation constraints (define totals from servings) ---
constraint
  totalCost = sum(f in FOODS)(cost[f] * servings[f]);

constraint
  totalProtein = sum(f in FOODS)(protein[f] * servings[f]);

constraint
  totalCarbs = sum(f in FOODS)(carbs[f] * servings[f]);

constraint
  totalCalories = sum(f in FOODS)(calories[f] * servings[f]);

% --- Nutritional requirement constraints (must meet or exceed daily needs) ---
constraint totalProtein  >= reqProtein;
constraint totalCarbs    >= reqCarbs;
constraint totalCalories >= reqCalories;


% Objective
solve minimize totalCost;
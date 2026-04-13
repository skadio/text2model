% Parameters
int: nFoods = 4;                            % number of food items
set of int: FOODS = 1..nFoods;              % index set for foods

array[FOODS] of int: cost = [4, 4, 2, 4];   % cost per unit: Chicken, Rice, Beans, Avocado
array[FOODS] of int: protein = [14, 5, 9, 10];   % grams protein per unit
array[FOODS] of int: carbs   = [7, 13, 26, 14];  % grams carbs per unit
array[FOODS] of int: calories= [208, 140, 280, 199]; % calories per unit

int: reqProtein = 74;                       % required grams of protein
int: reqCarbs   = 166;                      % required grams of carbohydrates
int: reqCalories= 2210;                     % required calories

% Variables
array[FOODS] of var 0..1000: qty;           % integer units of each food item chosen (bounded)
var 0..1000000: totalCost;                  % total cost (bounded)

% Constraints
% --- Nutrient requirement constraints (meet or exceed daily goals) ---
constraint sum(f in FOODS)(protein[f] * qty[f]) >= reqProtein;
constraint sum(f in FOODS)(carbs[f] * qty[f]) >= reqCarbs;
constraint sum(f in FOODS)(calories[f] * qty[f]) >= reqCalories;

% --- Cost aggregation constraint (define totalCost from chosen quantities) ---
constraint totalCost = sum(f in FOODS)(cost[f] * qty[f]);

% Objective
solve minimize totalCost;
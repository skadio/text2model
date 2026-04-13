% Parameters
int: nFoods = 4;                          % number of food items
set of int: FOODS = 1..nFoods;            % index set for foods

% Food names (for reference): 1=Steak, 2=Eggs, 3=Pasta, 4=Chicken
array[FOODS] of int: cost     = [4, 1, 9, 4];        % cost per unit
array[FOODS] of int: protein  = [20, 7, 1, 10];      % grams protein per unit
array[FOODS] of int: carbs    = [2, 3, 26, 1];       % grams carbs per unit
array[FOODS] of int: calories = [68, 143, 52, 69];   % calories per unit

int: minProtein  = 71;                    % required minimum protein
int: minCarbs    = 141;                   % required minimum carbohydrates
int: minCalories = 1839;                  % required minimum calories

% Variables
array[FOODS] of var 0..1000: qty;         % integer units of each food
var 0..100000: totalCost;                 % total cost to minimize

% Constraints
% Total cost definition
constraint totalCost = sum(f in FOODS)(cost[f] * qty[f]);

% Nutritional minimum requirements
constraint sum(f in FOODS)(protein[f] * qty[f]) >= minProtein;
constraint sum(f in FOODS)(carbs[f] * qty[f]) >= minCarbs;
constraint sum(f in FOODS)(calories[f] * qty[f]) >= minCalories;

% Objective
solve minimize totalCost;

% Output: only the optimal cost value
output [show(totalCost)];
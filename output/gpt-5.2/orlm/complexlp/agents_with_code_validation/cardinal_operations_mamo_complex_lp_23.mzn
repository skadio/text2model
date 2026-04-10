% Parameters
int: nFoods = 8;                       % number of available food items
set of int: FOODS = 1..nFoods;         % index set for foods

array[FOODS] of int: cost     = [6,4,4,3,2,7,3,3];                  % cost per unit of each food
array[FOODS] of int: protein  = [1,18,19,19,3,8,15,3];              % grams of protein per unit
array[FOODS] of int: carbs    = [4,2,26,10,24,26,27,30];            % grams of carbohydrates per unit
array[FOODS] of int: calories = [93,219,155,105,255,182,173,191];   % calories per unit

int: reqProtein  = 98;                  % minimum required protein
int: reqCarbs    = 113;                 % minimum required carbohydrates
int: reqCalories = 1768;                % minimum required calories

% Variables
array[FOODS] of var 0..1000: x;         % number of units selected for each food (nonnegative integer)

var 0..1000000: totalCost;              % total cost of the meal plan
var 0..1000000: totalProtein;           % total protein
var 0..1000000: totalCarbs;             % total carbohydrates
var 0..1000000: totalCalories;          % total calories

% Constraints
% Compute totals from chosen food quantities
constraint totalCost     = sum(f in FOODS)(cost[f] * x[f]);
constraint totalProtein  = sum(f in FOODS)(protein[f] * x[f]);
constraint totalCarbs    = sum(f in FOODS)(carbs[f] * x[f]);
constraint totalCalories = sum(f in FOODS)(calories[f] * x[f]);

% Satisfy minimum daily nutrition requirements
constraint totalProtein  >= reqProtein;
constraint totalCarbs    >= reqCarbs;
constraint totalCalories >= reqCalories;

% Objective
solve minimize totalCost;
% Diet / nutrition cost minimization (all data embedded)

include "globals.mzn";

set of int: FOODS = 1..5;
array[FOODS] of string: name = ["Chicken","Rice","Apples","Cheese","Tofu"];

% Nutrients per unit of each food
array[FOODS] of int: protein = [14,10,4,19,10];
array[FOODS] of int: carbs   = [28,27,13,5,8];
array[FOODS] of int: calories= [184,298,162,81,147];

% Cost per unit
array[FOODS] of int: cost = [5,1,5,9,9];

% Requirements (at least)
int: req_protein  = 97;
int: req_carbs    = 140;
int: req_calories = 2304;

% Decision: integer number of units of each food
% Upper bounds are safe and small (derived from minimum contribution per nutrient)
int: U = 30;
array[FOODS] of var 0..U: x;

% Meet requirements
constraint sum(i in FOODS)(protein[i] * x[i]) >= req_protein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= req_carbs;
constraint sum(i in FOODS)(calories[i]* x[i]) >= req_calories;

% Minimize total cost
var int: total_cost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize total_cost;

output [ show(total_cost) ];
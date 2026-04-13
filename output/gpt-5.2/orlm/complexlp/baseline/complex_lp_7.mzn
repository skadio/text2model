% Diet optimization: minimize cost while meeting nutrition requirements

set of int: FOODS = 1..5;
array[FOODS] of string: name = ["Chicken","Rice","Apples","Cheese","Tofu"];

array[FOODS] of int: protein = [14, 10, 4, 19, 10];
array[FOODS] of int: carbs   = [28, 27,13,  5,  8];
array[FOODS] of int: calories= [184,298,162, 81,147];
array[FOODS] of int: cost    = [ 5,  1, 5,  9,  9];

int: req_protein = 97;
int: req_carbs   = 140;
int: req_calories= 2304;

% Upper bound: if all calories came from the lowest-calorie item (Cheese: 81)
% we'd need at most ceil(2304/81)=29 units of any single food, so 0..29 is safe.
int: U = 29;

array[FOODS] of var 0..U: x; % number of units of each food

constraint sum(i in FOODS)(protein[i] * x[i]) >= req_protein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= req_carbs;
constraint sum(i in FOODS)(calories[i]* x[i]) >= req_calories;

var int: total_cost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize total_cost;

output [show(total_cost)];
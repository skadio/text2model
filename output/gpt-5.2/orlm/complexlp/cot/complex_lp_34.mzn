% Parameters (with values embedded)
enum Food = {Chicken, Tuna, Eggs, Beef, Rice, Apples, Bread};
int: nFoods = 7;

array[Food] of int: protein = [18, 12, 7, 17, 3, 4, 4];
array[Food] of int: carbs   = [23, 30, 16, 26, 30, 6, 23];
array[Food] of int: calories= [217, 182, 79, 295, 264, 160, 141];
array[Food] of int: cost    = [3, 10, 10, 7, 4, 6, 5];

int: target_protein  = 59;
int: target_carbs    = 160;
int: target_calories = 1809;

% Variables
array[Food] of var 0..1000: qty;  % number of servings/units of each food

var 0..1000000: total_cost;

% Constraints
constraint total_cost = sum(f in Food)(cost[f] * qty[f]);

constraint sum(f in Food)(protein[f]  * qty[f]) >= target_protein;
constraint sum(f in Food)(carbs[f]    * qty[f]) >= target_carbs;
constraint sum(f in Food)(calories[f] * qty[f]) >= target_calories;

% Objective
solve minimize total_cost;
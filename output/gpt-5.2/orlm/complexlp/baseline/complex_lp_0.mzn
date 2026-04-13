% Diet / meal plan optimization (all data embedded)

enum Food = {Steak, Tofu, Chicken, Broccoli, Rice, Spinach};

array[Food] of int: protein = [14, 2, 17, 3, 15, 2];
array[Food] of int: carbs   = [23, 13, 13, 1, 23, 8];
array[Food] of int: calories= [63, 162, 260, 55, 231, 297];
array[Food] of int: cost    = [4, 6, 6, 8, 8, 5];

int: req_protein  = 83;
int: req_carbs    = 192;
int: req_calories = 2089;

% Decision variables: number of servings of each food (nonnegative integers)
array[Food] of var 0..500: x;

constraint sum(f in Food)(protein[f]  * x[f]) >= req_protein;
constraint sum(f in Food)(carbs[f]    * x[f]) >= req_carbs;
constraint sum(f in Food)(calories[f] * x[f]) >= req_calories;

var int: total_cost = sum(f in Food)(cost[f] * x[f]);

solve minimize total_cost;

output [
  "Minimum cost = $", show(total_cost), "\n",
  "Servings:\n"
] ++ [ show(f) ++ ": " ++ show(x[f]) ++ "\n" | f in Food ];
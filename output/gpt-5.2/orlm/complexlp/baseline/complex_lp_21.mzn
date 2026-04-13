% Diet optimization: minimize cost while meeting nutrient minimums

enum Food = {Chicken, Rice, Vegetables, Bread, Almonds, Salmon};

array[Food] of int: protein = [16, 11, 1, 6, 2, 19];
array[Food] of int: carbs   = [8, 24, 5, 26, 11, 20];
array[Food] of int: calories= [50, 90, 164, 165, 51, 238];
array[Food] of int: cost    = [2, 3, 3, 2, 4, 10];

int: minProtein  = 58;
int: minCarbs    = 150;
int: minCalories = 2392;

% Decision: number of servings of each food (nonnegative integers)
array[Food] of var 0..200: x;

constraint sum(f in Food)(protein[f] * x[f]) >= minProtein;
constraint sum(f in Food)(carbs[f]   * x[f]) >= minCarbs;
constraint sum(f in Food)(calories[f]* x[f]) >= minCalories;

var int: total_cost = sum(f in Food)(cost[f] * x[f]);

solve minimize total_cost;

output [ show(total_cost) ];
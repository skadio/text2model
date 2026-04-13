% Diet optimization: minimize cost while meeting nutrient minimums.
% All data embedded.

enum Food = {Chicken, Oats, Tofu, Rice, Beef, Salmon};
int: n = card(Food);

array[Food] of int: cost = [6, 2, 9, 3, 7, 9];
array[Food] of int: protein = [14, 11, 8, 1, 16, 19];
array[Food] of int: carbs   = [1,  6, 12, 17, 11, 13];
array[Food] of int: calories= [164,210,98, 92, 211,211];

int: minProtein = 70;
int: minCarbs   = 117;
int: minCalories= 1837;

% Integer servings of each food (unbounded, but capped for search).
% Safe upper bounds: enough servings to meet each requirement if only that food were used.
int: ubProtein = max([ (minProtein + protein[f] - 1) div protein[f] | f in Food ]);
int: ubCarbs   = max([ (minCarbs   + carbs[f]   - 1) div carbs[f]   | f in Food ]);
int: ubCalories= max([ (minCalories+ calories[f]- 1) div calories[f]| f in Food ]);
int: UB = max([ubProtein, ubCarbs, ubCalories]);

array[Food] of var 0..UB: x;

constraint sum(f in Food)(protein[f] * x[f]) >= minProtein;
constraint sum(f in Food)(carbs[f]   * x[f]) >= minCarbs;
constraint sum(f in Food)(calories[f]* x[f]) >= minCalories;

var int: totalCost = sum(f in Food)(cost[f] * x[f]);

solve minimize totalCost;

output [ show(totalCost) ];
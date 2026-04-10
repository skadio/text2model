% Diet optimization: minimize cost while meeting nutrition minimums

enum Food = {Steak, Apples, Eggs, Chicken, Tofu};

array[Food] of int: cost = [6, 1, 1, 3, 1];

array[Food] of int: protein = [1, 7, 6, 20, 8];
array[Food] of int: carbs   = [3, 22, 18, 6, 4];
array[Food] of int: calories= [210, 96, 189, 132, 75];

int: minProtein  = 87;
int: minCarbs    = 135;
int: minCalories = 1926;

% Decision variables: number of servings of each food (nonnegative integers)
array[Food] of var 0..500: x;

constraint sum(f in Food)(protein[f] * x[f]) >= minProtein;
constraint sum(f in Food)(carbs[f]   * x[f]) >= minCarbs;
constraint sum(f in Food)(calories[f]* x[f]) >= minCalories;

var int: totalCost = sum(f in Food)(cost[f] * x[f]);

solve minimize totalCost;

output [
  "Servings:\n"
] ++
[ show(f) ++ " = " ++ show(x[f]) ++ "\n" | f in Food ] ++
[
  "\nTotals:\n",
  "Protein  = ", show(sum(f in Food)(protein[f] * x[f])), "\n",
  "Carbs    = ", show(sum(f in Food)(carbs[f]   * x[f])), "\n",
  "Calories = ", show(sum(f in Food)(calories[f]* x[f])), "\n",
  "\nMinimum cost = $", show(totalCost), "\n"
];
% Diet cost minimization with embedded data

enum Food = {Chicken, Pasta, Rice, Beans, Cheese};
int: n = card(Food);

array[Food] of int: protein = [5, 3, 11, 10, 4];
array[Food] of int: carbs   = [13, 23, 27, 27, 18];
array[Food] of int: calories= [121, 274, 251, 259, 199];
array[Food] of int: cost    = [7, 10, 7, 9, 7];

int: req_protein  = 60;
int: req_carbs    = 146;
int: req_calories = 1727;

% Upper bounds sufficient for feasibility (could be looser, but keep finite)
array[Food] of int: ub = [
  (req_calories div calories[Chicken]) + 10,
  (req_calories div calories[Pasta]) + 10,
  (req_calories div calories[Rice]) + 10,
  (req_calories div calories[Beans]) + 10,
  (req_calories div calories[Cheese]) + 10
];

array[Food] of var 0..max(ub): x;

constraint forall(f in Food)(x[f] <= ub[f]);

constraint sum(f in Food)(protein[f] * x[f])  >= req_protein;
constraint sum(f in Food)(carbs[f]   * x[f])  >= req_carbs;
constraint sum(f in Food)(calories[f]* x[f])  >= req_calories;

var int: total_cost = sum(f in Food)(cost[f] * x[f]);

solve minimize total_cost;

output [
  "Total cost: $", show(total_cost), "\n",
  "Quantities:\n",
  "  Chicken: ", show(x[Chicken]), "\n",
  "  Pasta:   ", show(x[Pasta]), "\n",
  "  Rice:    ", show(x[Rice]), "\n",
  "  Beans:   ", show(x[Beans]), "\n",
  "  Cheese:  ", show(x[Cheese]), "\n",
  "Totals:\n",
  "  Protein:  ", show(sum(f in Food)(protein[f]*x[f])), " g\n",
  "  Carbs:    ", show(sum(f in Food)(carbs[f]*x[f])), " g\n",
  "  Calories: ", show(sum(f in Food)(calories[f]*x[f])), "\n"
];
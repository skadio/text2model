% Diet optimization: minimize cost while meeting minimum nutrition requirements

set of int: FOODS = 1..4;
int: Eggs = 1;
int: Rice = 2;
int: Chicken = 3;
int: Broccoli = 4;

array[FOODS] of int: cost = [6, 10, 1, 7];

array[FOODS] of int: protein = [4, 1, 10, 8];
array[FOODS] of int: carbs   = [13, 13, 29, 26];
array[FOODS] of int: calories= [238, 85, 146, 139];

int: req_protein  = 93;
int: req_carbs    = 165;
int: req_calories = 1553;

% Upper bounds based on cheapest-per-unit reasoning (safe, small enough)
int: max_qty = 200;

array[FOODS] of var 0..max_qty: x; % number of units of each food

constraint sum(i in FOODS)(protein[i]  * x[i]) >= req_protein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= req_carbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= req_calories;

var int: total_cost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize total_cost;

output [
  "Eggs=", show(x[Eggs]), "\n",
  "Rice=", show(x[Rice]), "\n",
  "Chicken=", show(x[Chicken]), "\n",
  "Broccoli=", show(x[Broccoli]), "\n",
  "Total cost=", show(total_cost), "\n"
];
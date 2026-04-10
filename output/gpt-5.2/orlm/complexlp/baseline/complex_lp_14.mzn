% Diet / nutrition cost minimization with embedded data

set of int: FOODS = 1..8;
array[FOODS] of string: food = ["Eggs","Grains","Berries","Nuts","Salmon","Vegetables","Rice","Meat"];

array[FOODS] of int: cost  = [4, 3, 2, 4, 9, 3, 6, 6];
array[FOODS] of int: prot  = [2, 7, 6, 16, 20, 6, 6, 5];
array[FOODS] of int: carb  = [4, 9, 18, 3, 11, 27, 30, 1];
array[FOODS] of int: cal   = [282, 104, 71, 116, 175, 132, 251, 74];

int: req_prot = 84;
int: req_carb = 195;
int: req_cal  = 1941;

% Decision variables: number of servings of each food (nonnegative integers)
array[FOODS] of var int: x;
constraint forall(i in FOODS)(x[i] >= 0);

% Nutritional requirements
constraint sum(i in FOODS)(prot[i] * x[i]) >= req_prot;
constraint sum(i in FOODS)(carb[i] * x[i]) >= req_carb;
constraint sum(i in FOODS)(cal[i]  * x[i]) >= req_cal;

% Objective: minimize total cost
var int: total_cost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize total_cost;

output [
  "Minimum cost: $", show(total_cost), "\n",
  "Servings:\n"
] ++
[
  food[i] ++ ": " ++ show(x[i]) ++ "\n"
  | i in FOODS
] ++
[
  "\nTotals:\n",
  "Protein: ", show(sum(i in FOODS)(prot[i]*x[i])), " (>= ", show(req_prot), ")\n",
  "Carbs:   ", show(sum(i in FOODS)(carb[i]*x[i])), " (>= ", show(req_carb), ")\n",
  "Calories:", show(sum(i in FOODS)(cal[i]*x[i])),  " (>= ", show(req_cal), ")\n"
];
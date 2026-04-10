int: n = 5;
set of int: FOODS = 1..n;

array[FOODS] of string: name = ["Chicken","Rice","Broccoli","Tofu","Beans"];

array[FOODS] of int: protein = [18,12,13,5,10];
array[FOODS] of int: carbs   = [6,28,19,16,20];
array[FOODS] of int: cal     = [142,88,137,141,150];
array[FOODS] of int: cost    = [4,8,7,10,1];

int: req_protein = 56;
int: req_carbs   = 194;
int: req_cal     = 2012;

% Decision variables: number of servings of each food (nonnegative integers)
array[FOODS] of var 0..1000: x;

constraint sum(f in FOODS)(protein[f] * x[f]) >= req_protein;
constraint sum(f in FOODS)(carbs[f]   * x[f]) >= req_carbs;
constraint sum(f in FOODS)(cal[f]     * x[f]) >= req_cal;

var int: total_cost = sum(f in FOODS)(cost[f] * x[f]);

solve minimize total_cost;

output [
  "Minimal cost: $", show(total_cost), "\n",
  "Servings:\n"
] ++ [
  name[f] ++ ": " ++ show(x[f]) ++ "\n" | f in FOODS
] ++ [
  "Totals -> Protein: " ++ show(sum(f in FOODS)(protein[f]*x[f])) ++
  ", Carbs: " ++ show(sum(f in FOODS)(carbs[f]*x[f])) ++
  ", Calories: " ++ show(sum(f in FOODS)(cal[f]*x[f])) ++ "\n"
];
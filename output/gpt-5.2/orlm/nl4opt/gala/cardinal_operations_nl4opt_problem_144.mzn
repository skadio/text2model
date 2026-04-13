% Diet / nutrition cost minimization (integer servings)

int: vit_per_veg = 2;
int: min_per_veg = 3;
int: cost_veg    = 3;

int: vit_per_fruit = 4;
int: min_per_fruit = 1;
int: cost_fruit    = 5;

int: vit_req = 20;
int: min_req = 30;

% Decision variables: number of servings (nonnegative integers)
var 0..1000: veg;
var 0..1000: fruit;

% Nutrition requirements
constraint vit_per_veg * veg + vit_per_fruit * fruit >= vit_req;
constraint min_per_veg * veg + min_per_fruit * fruit >= min_req;

% Objective: minimize total cost
var int: total_cost = cost_veg * veg + cost_fruit * fruit;

solve minimize total_cost;

output [
  "Vegetable servings = ", show(veg), "\n",
  "Fruit servings     = ", show(fruit), "\n",
  "Total cost         = $", show(total_cost), "\n",
  "Vitamins           = ", show(vit_per_veg * veg + vit_per_fruit * fruit), "\n",
  "Minerals           = ", show(min_per_veg * veg + min_per_fruit * fruit), "\n"
];
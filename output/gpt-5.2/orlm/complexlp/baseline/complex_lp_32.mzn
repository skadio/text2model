% Diet optimization (all data embedded)

set of int: FOODS = 1..6;
array[FOODS] of string: name = ["Pasta","Avocado","Chicken","Tofu","Spinach","Cheese"];

array[FOODS] of int: protein = [15,20,15,19,19,12];
array[FOODS] of int: carbs   = [30,16, 8, 5,28,17];
array[FOODS] of int: calories= [154,111,211, 87,98,231];
array[FOODS] of int: cost    = [3,8,7,2,9,10];

int: req_protein = 73;
int: req_carbs   = 111;
int: req_cal     = 2196;

% Upper bounds (safe): if we used only the best item for each requirement.
int: max_units = max([
  (req_protein + min(protein) - 1) div min(protein),
  (req_carbs   + min(carbs)   - 1) div min(carbs),
  (req_cal     + min(calories)- 1) div min(calories)
]);

array[FOODS] of var 0..max_units: x; % units of each food (nonnegative integers)

constraint sum(f in FOODS)(protein[f]*x[f]) >= req_protein;
constraint sum(f in FOODS)(carbs[f]*x[f])   >= req_carbs;
constraint sum(f in FOODS)(calories[f]*x[f])>= req_cal;

var int: total_cost = sum(f in FOODS)(cost[f]*x[f]);

solve minimize total_cost;

output [ show(total_cost) ];
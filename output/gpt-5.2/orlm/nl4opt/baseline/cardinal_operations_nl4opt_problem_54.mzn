% Diet optimization: minimize cost while meeting nutrient requirements

int: min_calcium = 100;
int: min_iron = 50;

int: cost_milk = 1;
int: calcium_milk = 40;
int: iron_milk = 25;

int: cost_veg = 2;
int: calcium_veg = 15;
int: iron_veg = 30;

var 0..100: milk;        % glasses of milk
var 0..100: vegetables;  % plates of vegetables

constraint calcium_milk * milk + calcium_veg * vegetables >= min_calcium;
constraint iron_milk * milk + iron_veg * vegetables >= min_iron;

var int: total_cost = cost_milk * milk + cost_veg * vegetables;

solve minimize total_cost;

output [
  "milk = ", show(milk), "\n",
  "vegetables = ", show(vegetables), "\n",
  "total_cost = $", show(total_cost), "\n",
  "calcium = ", show(calcium_milk * milk + calcium_veg * vegetables), "\n",
  "iron = ", show(iron_milk * milk + iron_veg * vegetables), "\n"
];
% Pizza production planning: minimize total baking time

int: dough_large = 12;
int: topping_large = 5;
int: time_large = 12;

int: dough_medium = 8;
int: topping_medium = 4;
int: time_medium = 8;

int: min_dough = 10000;
int: min_toppings = 4400;

int: min_medium = 200;

% Decision variables
var 0..1000000: L; % number of large pizzas
var 0..1000000: M; % number of medium pizzas

constraint dough_large * L + dough_medium * M >= min_dough;
constraint topping_large * L + topping_medium * M >= min_toppings;

constraint M >= min_medium;
constraint L >= 2 * M;

var int: total_time = time_large * L + time_medium * M;

solve minimize total_time;

output [
  "Large pizzas: ", show(L), "\n",
  "Medium pizzas: ", show(M), "\n",
  "Total baking time (minutes): ", show(total_time), "\n"
];
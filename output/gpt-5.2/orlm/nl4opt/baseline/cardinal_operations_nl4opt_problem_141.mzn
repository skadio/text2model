int: budget = 20000;
int: cost_mango = 5;
int: cost_guava = 3;

int: profit_mango = 3;
int: profit_guava = 4;

int: mango_min = 100;
int: mango_max = 150;

var mango_min..mango_max: mangos;
var 0..mango_max: guavas;

constraint cost_mango * mangos + cost_guava * guavas <= budget;
constraint 3 * guavas <= mangos; % guavas <= mangos/3

var int: total_profit = profit_mango * mangos + profit_guava * guavas;
solve maximize total_profit;

output [
  "mangos = ", show(mangos), "\n",
  "guavas = ", show(guavas), "\n",
  "profit = ", show(total_profit), "\n",
  "cost = ", show(cost_mango * mangos + cost_guava * guavas), "\n"
];
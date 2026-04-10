% Supplement purchase optimization (integer pills)

int: iron_req = 40;
int: calcium_req = 50;

int: iron_A = 5;
int: calcium_A = 10;
int: cost_A = 2;

int: iron_B = 4;
int: calcium_B = 15;
int: cost_B = 3;

% Decision variables: number of pills (nonnegative integers)
var 0..100: xA;
var 0..100: xB;

constraint iron_A * xA + iron_B * xB >= iron_req;
constraint calcium_A * xA + calcium_B * xB >= calcium_req;

var int: total_cost = cost_A * xA + cost_B * xB;

solve minimize total_cost;

output [
  "Supplement A pills = ", show(xA), "\n",
  "Supplement B pills = ", show(xB), "\n",
  "Total cost = $", show(total_cost), "\n",
  "Iron provided = ", show(iron_A * xA + iron_B * xB), "\n",
  "Calcium provided = ", show(calcium_A * xA + calcium_B * xB), "\n"
];
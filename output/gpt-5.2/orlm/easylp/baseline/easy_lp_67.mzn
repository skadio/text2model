int: max_acres = 1000;

int: cost_wheat = 4;
int: cost_corn  = 3;

var 0..max_acres: wheat;
var 0..max_acres: corn;

constraint wheat + corn <= max_acres;
constraint 2*wheat + 4*corn >= 800;
constraint 3*wheat - corn <= 500;

var int: total_cost = cost_wheat*wheat + cost_corn*corn;

solve minimize total_cost;

output [
  "wheat=", show(wheat), "\n",
  "corn=", show(corn), "\n",
  "total_cost=", show(total_cost), "\n"
];
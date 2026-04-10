% Manufacturing production planning: Steel and Aluminum
% Minimize total cost with capacity and minimum demand constraints.

int: capacity = 5000;

int: minSteel = 1000;
int: minAluminum = 2000;

int: costSteel = 20;
int: costAluminum = 30;

var int: steel;
var int: aluminum;

constraint steel >= minSteel;
constraint aluminum >= minAluminum;
constraint steel + aluminum <= capacity;

var int: total_cost = costSteel * steel + costAluminum * aluminum;

solve minimize total_cost;

output [
  "steel=", show(steel), "\n",
  "aluminum=", show(aluminum), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];
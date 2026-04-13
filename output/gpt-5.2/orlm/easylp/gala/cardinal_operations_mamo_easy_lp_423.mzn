% Manufacturing cost minimization (all data embedded)

int: capacity = 5000;

int: minSteel = 1000;
int: minAlum  = 2000;

int: costSteel = 20;
int: costAlum  = 30;

var minSteel..capacity: steel;
var minAlum..capacity: alum;

constraint steel + alum <= capacity;

var int: totalCost = costSteel * steel + costAlum * alum;

solve minimize totalCost;

output [
  "Steel = ", show(steel), "\n",
  "Aluminum = ", show(alum), "\n",
  "Minimum total cost ($) = ", show(totalCost), "\n"
];
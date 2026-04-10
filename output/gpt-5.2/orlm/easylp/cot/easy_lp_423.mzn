% Parameters (with values embedded)
int: capacity = 5000;
int: minSteel = 1000;
int: minAluminum = 2000;
int: costSteel = 20;
int: costAluminum = 30;

% Variables
var 0..capacity: Steel;
var 0..capacity: Aluminum;
var 0..(costSteel*capacity + costAluminum*capacity): TotalCost;

% Constraints
constraint Steel + Aluminum <= capacity;
constraint Steel >= minSteel;
constraint Aluminum >= minAluminum;

constraint TotalCost = costSteel * Steel + costAluminum * Aluminum;

% Objective
solve minimize TotalCost;

output [
  "Steel = ", show(Steel), "\n",
  "Aluminum = ", show(Aluminum), "\n",
  "Minimum total cost ($) = ", show(TotalCost), "\n"
];
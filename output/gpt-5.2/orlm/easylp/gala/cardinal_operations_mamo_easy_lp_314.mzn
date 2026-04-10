% Resource allocation MILP as an integer program in MiniZinc

% Data (embedded as required)
int: maxResources = 100;
int: minEffectiveness = 350;

int: effX = 5;
int: effY = 3;
int: effZ = 7;

int: costX = 5000;
int: costY = 4000;
int: costZ = 6000;

% Decision variables: whole-number resource units
var 0..maxResources: x;
var 0..maxResources: y;
var 0..maxResources: z;

% Constraints
constraint x + y + z <= maxResources;
constraint effX * x + effY * y + effZ * z >= minEffectiveness;
% "twice the number of resources allocated to Operations X and Y subtracted from those for operation Z should be non-negative"
constraint z - 2 * (x + y) >= 0;

% Objective: minimize total cost
var int: totalCost = costX * x + costY * y + costZ * z;

solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "totalCost = ", show(totalCost), "\n"
];
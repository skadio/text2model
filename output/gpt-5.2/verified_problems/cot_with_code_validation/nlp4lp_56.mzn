% Transportation problem: terminals -> ports

% Parameters
int: NumPorts;
int: NumTerminals;

array[1..NumTerminals, 1..NumPorts] of int: Cost;
array[1..NumPorts] of int: Demand;
array[1..NumTerminals] of int: Supply;

% Variables
array[1..NumTerminals, 1..NumPorts] of var 0..sum(Supply): Ship;

var int: TotalCost = sum(k in 1..NumTerminals, l in 1..NumPorts)(Cost[k,l] * Ship[k,l]);

% Constraints
constraint forall(k in 1..NumTerminals)(
  sum(l in 1..NumPorts)(Ship[k,l]) <= Supply[k]
);

constraint forall(l in 1..NumPorts)(
  sum(k in 1..NumTerminals)(Ship[k,l]) >= Demand[l]
);

% Objective
solve minimize TotalCost;

output [
  "TotalCost = ", show(TotalCost), "\n",
  "Ship =\n",
  show(Ship), "\n"
];
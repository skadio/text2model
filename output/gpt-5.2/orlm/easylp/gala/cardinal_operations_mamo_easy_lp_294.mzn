include "globals.mzn";

% Embedded data (no .dzn expected)
int: budget = 100;

set of int: Depts = 1..3;              % 1=X, 2=Y, 3=Z
array[Depts] of int: minFunding = [30, 20, 10];
array[Depts] of int: costPerUnit = [20, 15, 10];

% Decision variables: whole-number funding allocations
array[Depts] of var 0..budget: fund;

% Budget limit and minimum requirements
constraint sum(d in Depts)(fund[d]) <= budget;
constraint forall(d in Depts)(fund[d] >= minFunding[d]);

% Objective: minimize total cost
var int: totalCost = sum(d in Depts)(costPerUnit[d] * fund[d]);

solve minimize totalCost;

output [
  "Funding X,Y,Z = ", show([fund[1], fund[2], fund[3]]), "\n",
  "Total cost (rounded) = ", show(totalCost), "\n"
];
% Parameters (with values embedded)
int: M = 4; % potential distribution centers
int: N = 6; % retail stores

set of int: Centers = 1..M;
set of int: Stores  = 1..N;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000];

array[Centers, Stores] of int: transCost =
  [| 5, 5, 2, 3, 3, 3
   | 5, 4, 3, 5, 2, 4
   | 2, 4, 5, 1, 4, 2
   | 5, 4, 1, 1, 3, 3 |];

array[Stores] of int: demand = [910, 875, 589, 962, 966, 643];
array[Centers] of int: supply = [1631, 1954, 1446, 820];

int: totalDemand = sum(Stores)(demand[s]);
int: maxSupply = max(c in Centers)(supply[c]);

% Variables
array[Centers] of var bool: open;
array[Centers, Stores] of var 0..maxSupply: ship;

% Constraints
constraint
  forall(s in Stores) (
    sum(c in Centers)(ship[c,s]) = demand[s]
  );

constraint
  forall(c in Centers) (
    sum(s in Stores)(ship[c,s]) <= supply[c] * bool2int(open[c])
  );

% Objective
var int: totalCost =
    sum(c in Centers)(openCost[c] * bool2int(open[c]))
  + sum(c in Centers, s in Stores)(transCost[c,s] * ship[c,s]);

solve minimize totalCost;

output [
  "Optimal total cost = ", show(totalCost), "\n",
  "Open centers = ", show([bool2int(open[c]) | c in Centers]), "\n",
  "Shipments (center x store):\n",
  concat([ concat([ "  c", show(c), ": ", show([ship[c,s] | s in Stores]), "\n" ])
         | c in Centers ])
];
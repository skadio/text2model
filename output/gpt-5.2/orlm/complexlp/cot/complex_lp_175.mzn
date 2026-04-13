% Parameters (with values embedded)
int: M = 5; % potential distribution centers
int: N = 9; % retail stores

set of int: Centers = 1..M;
set of int: Stores  = 1..N;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000, 160000];

array[Centers, Stores] of int: transCost =
[
  % stores:   1  2  3  4  5  6  7  8  9
              5, 2, 3, 3, 3, 5, 4, 3, 5,   % center 1
              2, 4, 2, 4, 5, 1, 4, 2, 5,   % center 2
              4, 1, 1, 3, 3, 2, 4, 4, 3,   % center 3
              4, 4, 1, 3, 5, 3, 5, 1, 2,   % center 4
              4, 1, 4, 2, 2, 1, 2, 5, 2    % center 5
];

array[Stores] of int: demand = [739, 491, 766, 854, 827, 908, 434, 605, 480];

array[Centers] of int: capacity = [1825, 1821, 1365, 1929, 1502];

int: totalDemand = sum(s in Stores)(demand[s]);

% Variables
array[Centers] of var bool: open;
array[Centers, Stores] of var 0..totalDemand: ship;

var int: totalCost;

% Constraints
constraint
  forall(s in Stores)(
    sum(c in Centers)(ship[c,s]) = demand[s]
  );

constraint
  forall(c in Centers)(
    sum(s in Stores)(ship[c,s]) <= capacity[c]
  );

constraint
  forall(c in Centers)(
    sum(s in Stores)(ship[c,s]) <= capacity[c] * bool2int(open[c])
  );

% Objective
constraint
  totalCost =
    sum(c in Centers)(openCost[c] * bool2int(open[c])) +
    sum(c in Centers, s in Stores)(transCost[c,s] * ship[c,s]);

solve minimize totalCost;

output [
  "Optimal total cost = ", show(totalCost), "\n",
  "Open centers: ", show([bool2int(open[c]) | c in Centers]), "\n"
];
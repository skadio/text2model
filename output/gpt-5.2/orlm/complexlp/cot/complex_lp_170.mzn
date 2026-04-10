% Parameters (with values embedded)
int: M = 5; % distribution centers
int: N = 9; % stores

set of int: Centers = 1..M;
set of int: Stores  = 1..N;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000, 160000];

% Transportation costs per unit from each center to each store
array[Centers, Stores] of int: transCost =
[
  % s1 s2 s3 s4 s5 s6 s7 s8 s9
  |  5,  2,  3,  6,  4,  7,  3,  4,  5  % center 1
  |  2,  4,  6,  3,  5,  4,  7,  2,  5  % center 2
  |  4,  3,  5,  2,  6,  3,  4,  5,  2  % center 3
  |  6,  5,  2,  4,  3,  6,  2,  3,  4  % center 4
  |  3,  6,  4,  5,  2,  4,  5,  6,  3  % center 5
];

array[Stores] of int: demand = [739, 491, 612, 580, 531, 403, 689, 512, 480];

array[Centers] of int: capacity = [1825, 1821, 1365, 1929, 1502];

int: totalDemand = sum(i in Stores)(demand[i]);

% Variables
array[Centers] of var 0..1: open;
array[Centers, Stores] of var 0..totalDemand: ship;

var 0..(sum(c in Centers)(openCost[c]) + totalDemand * 1000): totalCost;

% Constraints
constraint
  forall(s in Stores)(
    sum(c in Centers)(ship[c,s]) = demand[s]
  );

constraint
  forall(c in Centers)(
    sum(s in Stores)(ship[c,s]) <= capacity[c] * open[c]
  );

% Objective
constraint
  totalCost =
    sum(c in Centers)(openCost[c] * open[c]) +
    sum(c in Centers, s in Stores)(transCost[c,s] * ship[c,s]);

solve minimize totalCost;
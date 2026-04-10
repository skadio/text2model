% Parameters (with values embedded)
int: N = 9; % distribution centers
int: M = 6; % retail stores

set of int: Centers = 1..N;
set of int: Stores  = 1..M;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000, 174000];

array[Centers, Stores] of int: transCost =
[
  % s1 s2 s3 s4 s5 s6
  |  3, 5, 4, 3, 5, 2   % c1
  |, 4, 2, 4, 5, 1, 4   % c2
  |, 2, 5, 4, 1, 1, 3   % c3
  |, 3, 2, 4, 4, 3, 4   % c4
  |, 4, 1, 3, 5, 3, 5   % c5
  |, 1, 2, 4, 1, 4, 2   % c6
  |, 2, 1, 2, 5, 2, 4   % c7
  |, 4, 4, 4, 5, 3, 1   % c8
  |, 4, 2, 4, 2, 2, 4   % c9
];

array[Stores] of int: demand = [876, 801, 955, 561, 601, 669];

array[Centers] of int: capacity = [1615, 1255, 1816, 1095, 1519, 1137, 1678, 1876, 1591];

int: maxDemand = max(demand);
int: maxCapacity = max(capacity);

% Variables
array[Centers] of var bool: open;
array[Centers, Stores] of var 0..maxDemand: ship;

% Constraints
constraint
  forall(j in Stores) (
    sum(i in Centers)(ship[i,j]) = demand[j]
  );

constraint
  forall(i in Centers) (
    sum(j in Stores)(ship[i,j]) <= capacity[i] * bool2int(open[i])
  );

% Objective
var int: totalCost =
  sum(i in Centers)(openCost[i] * bool2int(open[i])) +
  sum(i in Centers, j in Stores)(transCost[i,j] * ship[i,j]);

solve minimize totalCost;

output [
  "Minimal total cost = ", show(totalCost), "\n",
  "Open centers: ", show([i | i in Centers where fix(open[i]) = true]), "\n"
];
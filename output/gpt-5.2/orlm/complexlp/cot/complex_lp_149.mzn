% Parameters (with values embedded)
int: M = 6; % distribution centers
int: N = 9; % retail stores

set of int: Centers = 1..M;
set of int: Stores  = 1..N;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000];

% Transportation cost per unit from center i to store j
array[Centers, Stores] of int: transCost =
[
  % s1 s2 s3 s4 s5 s6 s7 s8 s9
  |  2, 3, 4, 5, 6, 7, 6, 3, 2  % center 1
  |  4, 2, 3, 4, 5, 6, 7, 5, 4  % center 2
  |  3, 4, 2, 3, 4, 5, 6, 4, 3  % center 3
  |  5, 3, 4, 2, 3, 4, 5, 4, 5  % center 4
  |  6, 5, 3, 4, 2, 3, 4, 5, 6  % center 5
  |  7, 6, 5, 4, 3, 2, 3, 6, 7  % center 6
];

array[Stores] of int: demand = [401, 789, 965, 505, 876, 801, 955, 561, 601];
array[Centers] of int: capacity = [1795, 1069, 1615, 1255, 1816, 1095];

int: totalDemand = sum(j in Stores)(demand[j]);

% Variables
array[Centers] of var bool: open;
array[Centers, Stores] of var 0..totalDemand: ship; % units shipped from center i to store j

% Constraints
constraint
  forall(j in Stores)(
    sum(i in Centers)(ship[i,j]) = demand[j]
  );

constraint
  forall(i in Centers)(
    sum(j in Stores)(ship[i,j]) <= capacity[i] * bool2int(open[i])
  );

% Objective
var int: totalCost =
  sum(i in Centers)(openCost[i] * bool2int(open[i]))
+ sum(i in Centers, j in Stores)(transCost[i,j] * ship[i,j]);

solve minimize totalCost;
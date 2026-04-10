% Parameters (with values embedded)
int: M = 6; % potential distribution centers
int: N = 8; % retail stores

set of int: Centers = 1..M;
set of int: Stores  = 1..N;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000];

% Transportation cost per unit from center i to store j
array[Centers, Stores] of int: shipCost =
[
  % stores:  1  2  3  4  5  6  7  8
            2, 3, 4, 2, 3, 4, 2, 5,  % center 1
            2, 4, 3, 2, 4, 3, 2, 2,  % center 2
            5, 4, 3, 4, 5, 4, 3, 4,  % center 3
            4, 3, 2, 3, 4, 3, 2, 3,  % center 4
            5, 1, 2, 1, 3, 2, 1, 2,  % center 5
            1, 2, 3, 2, 1, 2, 3, 4   % center 6
];

array[Stores] of int: demand = [908, 434, 605, 480, 961, 787, 401, 789];
array[Centers] of int: capacity = [1365, 1929, 1502, 1201, 1529, 961];

int: totalDemand = sum(j in Stores)(demand[j]);

% Variables
array[Centers] of var bool: open;
array[Centers, Stores] of var 0..totalDemand: x; % units shipped from center i to store j

var int: totalOpenCost;
var int: totalShipCost;
var int: totalCost;

% Constraints
constraint
  forall(j in Stores) (
    sum(i in Centers)(x[i,j]) = demand[j]
  );

constraint
  forall(i in Centers) (
    sum(j in Stores)(x[i,j]) <= capacity[i] * bool2int(open[i])
  );

constraint
  totalOpenCost = sum(i in Centers)(openCost[i] * bool2int(open[i]));

constraint
  totalShipCost = sum(i in Centers, j in Stores)(shipCost[i,j] * x[i,j]);

constraint
  totalCost = totalOpenCost + totalShipCost;

% Objective
solve minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "totalOpenCost=", show(totalOpenCost), "\n",
  "totalShipCost=", show(totalShipCost), "\n",
  "open=", show(open), "\n",
  "x=\n"
] ++
[
  "center " ++ show(i) ++ ": " ++ show([x[i,j] | j in Stores]) ++ "\n"
  | i in Centers
];
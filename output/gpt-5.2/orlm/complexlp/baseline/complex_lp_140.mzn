% Capacitated Facility Location / Distribution Center Opening + Shipping
% All data embedded as requested.

int: I = 7; % centers
int: J = 7; % stores

set of int: Centers = 1..I;
set of int: Stores  = 1..J;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000];

array[Centers, Stores] of int: shipCost =
[
  % stores: 1  2  3  4  5  6  7
  |  3, 3, 5, 4, 3, 5, 2   % center 1
  |  4, 2, 4, 5, 1, 4, 2   % center 2
  |  5, 4, 1, 1, 3, 3, 2   % center 3
  |  4, 4, 3, 4, 4, 1, 3   % center 4
  |  5, 3, 5, 1, 2, 4, 1   % center 5
  |  4, 2, 2, 1, 2, 5, 2   % center 6
  |  4, 4, 4, 4, 5, 3, 1   % center 7
];

array[Stores] of int: demand = [961, 787, 401, 789, 965, 505, 876];
array[Centers] of int: cap    = [1502, 1201, 1529, 961, 1001, 1795, 1069];

int: totalDemand = sum(Stores)(demand[j]);
int: maxShip = totalDemand;

array[Centers] of var bool: open;
array[Centers, Stores] of var 0..maxShip: x; % units shipped from center i to store j

% Each store's demand must be met exactly.
constraint forall(j in Stores)(
  sum(i in Centers)(x[i,j]) = demand[j]
);

% Center capacity only available if opened.
constraint forall(i in Centers)(
  sum(j in Stores)(x[i,j]) <= cap[i] * bool2int(open[i])
);

% Objective: opening + shipping costs
var int: totalCost =
  sum(i in Centers)(openCost[i] * bool2int(open[i])) +
  sum(i in Centers, j in Stores)(shipCost[i,j] * x[i,j]);

solve minimize totalCost;

output [
  "Optimal total cost = ", show(totalCost), "\n",
  "Opened centers: ", show([i | i in Centers where fix(open[i]) = true]), "\n"
];
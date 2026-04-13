% Facility location / transportation (capacitated) model
int: M = 6; % distribution centers
int: N = 9; % retail stores

set of int: DC = 1..M;
set of int: ST = 1..N;

array[DC] of int: open_cost = [151000, 192000, 114000, 171000, 160000, 120000];
array[ST] of int: demand    = [401, 789, 965, 505, 876, 801, 955, 561, 601];
array[DC] of int: capacity  = [1795, 1069, 1615, 1255, 1816, 1095];

% Transportation costs per unit (DC x Store)
array[DC, ST] of int: trans_cost = array2d(DC, ST, [
  2, 3, 1, 5, 4, 2, 3, 4, 2,
  4, 2, 3, 6, 5, 3, 2, 5, 4,
  3, 4, 2, 4, 3, 5, 4, 3, 5,
  5, 3, 4, 2, 4, 3, 5, 2, 3,
  4, 5, 3, 4, 2, 4, 3, 5, 2,
  2, 4, 5, 3, 5, 2, 4, 3, 4
]);

int: total_demand = sum(s in ST)(demand[s]);

% Decision variables
array[DC] of var bool: open;
array[DC, ST] of var 0..total_demand: ship;

% Constraints: satisfy each store demand exactly
constraint forall(s in ST) (
  sum(d in DC)(ship[d,s]) = demand[s]
);

% Capacity only if DC is open
constraint forall(d in DC) (
  sum(s in ST)(ship[d,s]) <= capacity[d] * bool2int(open[d])
);

% Objective: opening + shipping costs
var int: total_cost =
  sum(d in DC)(open_cost[d] * bool2int(open[d])) +
  sum(d in DC, s in ST)(trans_cost[d,s] * ship[d,s]);

solve minimize total_cost;

output ["total_cost = ", show(total_cost), "\n"];
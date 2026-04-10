% Facility location + transportation (capacitated)
int: M = 8; % distribution centers
int: N = 9; % retail stores

set of int: DC = 1..M;
set of int: ST = 1..N;

array[DC] of int: open_cost = [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000];

array[DC, ST] of int: trans_cost =
  array2d(DC, ST, [
    3, 3, 5, 4, 3, 5, 2, 4, 2,
    4, 5, 1, 4, 2, 5, 4, 1, 1,
    3, 3, 2, 4, 4, 3, 4, 4, 1,
    3, 5, 3, 5, 1, 2, 4, 1, 4,
    2, 2, 1, 2, 5, 2, 4, 4, 4,
    4, 5, 3, 1, 4, 2, 4, 2, 2,
    4, 5, 2, 2, 4, 2, 2, 4, 4,
    1, 5, 5, 2, 5, 2, 1, 4, 4
  ]);

array[ST] of int: demand = [779, 892, 440, 556, 414, 464, 920, 743, 528];
array[DC] of int: capacity = [1447, 1886, 1962, 1392, 1191, 1218, 1088, 1178];

int: total_demand = sum(s in ST)(demand[s]);

% Decision variables
array[DC] of var bool: open;
array[DC, ST] of var 0..total_demand: ship;

% Constraints: satisfy all demands
constraint forall(s in ST)(
  sum(d in DC)(ship[d, s]) = demand[s]
);

% Capacity only if open
constraint forall(d in DC)(
  sum(s in ST)(ship[d, s]) <= capacity[d] * bool2int(open[d])
);

% Objective: minimize opening + transportation cost
var int: total_cost =
  sum(d in DC)(open_cost[d] * bool2int(open[d])) +
  sum(d in DC, s in ST)(trans_cost[d, s] * ship[d, s]);

solve minimize total_cost;

output ["total_cost = ", show(total_cost), "\n"];
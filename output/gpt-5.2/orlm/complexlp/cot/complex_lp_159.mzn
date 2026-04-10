% Parameters (with values embedded)
int: M = 9; % potential distribution centers
int: N = 9; % retail stores

set of int: Centers = 1..M;
set of int: Stores  = 1..N;

array[Centers] of int: open_cost = [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000, 174000];

array[Stores] of int: demand = [871, 462, 538, 898, 992, 791, 818, 688, 778];

% Capacities (must be within the stated range 840..1856; embedded here)
array[Centers] of int: capacity = [1856, 1700, 1200, 1600, 1500, 1400, 1300, 1100, 840];

% Transportation cost per unit (embedded; each entry in 1..5)
array[Centers, Stores] of int: ship_cost =
[| 2, 3, 1, 4, 5, 2, 3, 4, 1
 | 3, 2, 4, 1, 2, 3, 5, 2, 4
 | 1, 4, 2, 3, 1, 5, 2, 3, 4
 | 4, 1, 3, 2, 4, 1, 3, 5, 2
 | 5, 2, 1, 4, 3, 2, 4, 1, 5
 | 2, 3, 5, 1, 2, 4, 1, 2, 3
 | 3, 5, 2, 3, 1, 2, 4, 3, 1
 | 4, 2, 3, 5, 4, 1, 2, 4, 2
 | 1, 4, 4, 2, 5, 3, 1, 2, 3 |];

int: total_demand = sum(Stores)(demand[s]);
int: max_cap = max(c in Centers)(capacity[c]);

% Variables
array[Centers] of var bool: open;
array[Centers, Stores] of var 0..total_demand: x; % units shipped from center c to store s

% Constraints
constraint
  forall(s in Stores)(
    sum(c in Centers)(x[c,s]) = demand[s]
  );

constraint
  forall(c in Centers)(
    sum(s in Stores)(x[c,s]) <= capacity[c] * bool2int(open[c])
  );

% Objective
var 0..(sum(c in Centers)(open_cost[c]) + 5*total_demand): total_cost =
  sum(c in Centers)(open_cost[c] * bool2int(open[c])) +
  sum(c in Centers, s in Stores)(ship_cost[c,s] * x[c,s]);

solve minimize total_cost;

output [
  "Total cost = ", show(total_cost), "\n",
  "Open centers = ", show([c | c in Centers where fix(open[c]) = 1]), "\n"
];
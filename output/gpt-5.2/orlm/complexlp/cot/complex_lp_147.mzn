% Parameters (with values embedded)
int: num_centers = 8;
int: num_stores  = 9;

set of int: CENTERS = 1..num_centers;
set of int: STORES  = 1..num_stores;

array[CENTERS] of int: opening_cost = [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000];

array[CENTERS, STORES] of int: transport_cost =
[
  % stores:  1  2  3  4  5  6  7  8  9
            3, 3, 5, 4, 3, 5, 2, 4, 2,   % center 1
            4, 5, 1, 4, 2, 5, 4, 1, 1,   % center 2
            3, 3, 2, 4, 4, 3, 4, 4, 1,   % center 3
            3, 5, 3, 5, 1, 2, 4, 1, 4,   % center 4
            2, 2, 1, 2, 5, 2, 4, 4, 4,   % center 5
            4, 5, 3, 1, 4, 2, 4, 2, 2,   % center 6
            4, 5, 2, 2, 4, 2, 2, 4, 4,   % center 7
            1, 5, 5, 2, 5, 2, 1, 4, 4    % center 8
];

array[STORES] of int: demand = [779, 892, 440, 556, 414, 464, 920, 743, 528];

array[CENTERS] of int: capacity = [1447, 1886, 1962, 1392, 1191, 1218, 1088, 1178];

int: total_demand = sum(s in STORES)(demand[s]);

% Variables
array[CENTERS] of var bool: open;
array[CENTERS, STORES] of var 0..total_demand: ship;

var int: total_cost;

% Constraints
constraint
  forall(s in STORES) (
    sum(c in CENTERS)(ship[c,s]) = demand[s]
  );

constraint
  forall(c in CENTERS) (
    sum(s in STORES)(ship[c,s]) <= capacity[c] * bool2int(open[c])
  );

% Objective
constraint
  total_cost =
    sum(c in CENTERS)(opening_cost[c] * bool2int(open[c]))
  + sum(c in CENTERS, s in STORES)(transport_cost[c,s] * ship[c,s]);

solve minimize total_cost;
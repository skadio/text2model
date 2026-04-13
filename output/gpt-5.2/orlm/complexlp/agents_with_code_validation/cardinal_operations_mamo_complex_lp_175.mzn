% Facility location / transportation problem (embedded data)

%--------------------------
% Parameters
%--------------------------
int: num_centers = 5;
int: num_stores  = 9;

set of int: CENTERS = 1..num_centers;
set of int: STORES  = 1..num_stores;

array[CENTERS] of int: open_cost = [151000, 192000, 114000, 171000, 160000];
array[CENTERS] of int: capacity  = [1825,   1821,   1365,   1929,   1502  ];

array[STORES] of int: demand = [739, 491, 766, 854, 827, 908, 434, 605, 480];

% Transportation cost per unit from center c to store s
% (Fix: provide a proper 2D array literal, not an array of 1D arrays)
array[CENTERS, STORES] of int: transport_cost =
array2d(CENTERS, STORES,
[
  % Center 1
  5, 2, 3, 3, 3, 5, 4, 3, 5,
  % Center 2
  2, 4, 2, 4, 5, 1, 4, 2, 5,
  % Center 3
  4, 1, 1, 3, 3, 2, 4, 4, 3,
  % Center 4
  4, 4, 1, 3, 5, 3, 5, 1, 2,
  % Center 5
  4, 1, 4, 2, 2, 1, 2, 5, 2
]);

int: total_demand = sum(s in STORES)(demand[s]);

%--------------------------
% Decision variables
%--------------------------
array[CENTERS] of var bool: open;
array[CENTERS, STORES] of var 0..total_demand: ship;

var int: total_cost =
    sum(c in CENTERS)(open_cost[c] * bool2int(open[c]))
  + sum(c in CENTERS, s in STORES)(transport_cost[c,s] * ship[c,s]);

%--------------------------
% Constraints
%--------------------------
% Each store demand must be met
constraint forall(s in STORES)(
  sum(c in CENTERS)(ship[c,s]) = demand[s]
);

% Center capacity only if open
constraint forall(c in CENTERS)(
  sum(s in STORES)(ship[c,s]) <= capacity[c] * bool2int(open[c])
);

% Optional strengthening: if closed, cannot ship to any store
constraint forall(c in CENTERS, s in STORES)(
  ship[c,s] <= demand[s] * bool2int(open[c])
);

%--------------------------
% Objective
%--------------------------
solve minimize total_cost;

%--------------------------
% Output
%--------------------------
output [
  "total_cost=", show(total_cost), "\n",
  "open=", show(open), "\n"
];
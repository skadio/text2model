% Vaccine redistribution / transportation problem (4 cities)
% Goal: meet each city's demand at minimum transport cost.

int: N = 4;
set of int: CITIES = 1..N;

array[CITIES] of int: supply = [483, 265, 130, 361];
array[CITIES] of int: demand = [346, 221, 217, 293];

array[CITIES, CITIES] of int: cost =
  [| 0,  2, 19, 13
   | 34, 0, 10, 48
   | 46, 22, 0, 46
   | 48, 15, 23, 0 |];

% Upper bound on shipments: at most all surplus can move
int: total_surplus = sum(i in CITIES)(max(0, supply[i] - demand[i]));

% Decision variables: x[i,j] = vaccines shipped from city i to city j
array[CITIES, CITIES] of var 0..total_surplus: x;

% No self-shipments
constraint forall(i in CITIES)(x[i,i] = 0);

% Flow balance:
% final stock in city i = supply[i] - outgoing + incoming
% must be >= demand[i]
constraint forall(i in CITIES)(
  supply[i] - sum(j in CITIES)(x[i,j]) + sum(j in CITIES)(x[j,i]) >= demand[i]
);

var int: total_cost = sum(i in CITIES, j in CITIES)(cost[i,j] * x[i,j]);

solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "x =\n",
  concat([ concat([ if j=1 then "" else " " endif ++ show(x[i,j]) | j in CITIES ]) ++ "\n"
         | i in CITIES ])
];
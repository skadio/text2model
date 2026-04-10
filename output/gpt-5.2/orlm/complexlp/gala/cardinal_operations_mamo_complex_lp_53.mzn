include "globals.mzn";

% Vaccine re-distribution / transportation min-cost flow between 4 cities.
% Data embedded as required.

int: n = 4;
set of int: CITIES = 1..n;

array[CITIES] of int: have = [483, 265, 130, 361];
array[CITIES] of int: need = [346, 221, 217, 293];

% Cost to ship 1 vaccine from city i to city j (i != j); diagonal is 0 (unused).
array[CITIES, CITIES] of int: cost =
  [| 0,  2, 19, 13
   | 34, 0, 10, 48
   | 46,22, 0, 46
   | 48,15,23, 0 |];

% Decision: x[i,j] = number of vaccines shipped from i to j.
array[CITIES, CITIES] of var 0..max(have): x;

% No self-shipping
constraint forall(i in CITIES)( x[i,i] = 0 );

% Balance constraints: final(i) = have(i) - outgoing + incoming must be >= need(i)
constraint forall(i in CITIES)(
  have[i]
  - sum(j in CITIES where j != i)(x[i,j])
  + sum(j in CITIES where j != i)(x[j,i])
  >= need[i]
);

% Optional: cannot ship out more than available at each origin (redundant but tightens)
constraint forall(i in CITIES)(
  sum(j in CITIES where j != i)(x[i,j]) <= have[i]
);

% Objective: minimize total shipping cost
var int: total_cost =
  sum(i in CITIES, j in CITIES where i != j)( cost[i,j] * x[i,j] );

solve minimize total_cost;

output [
  "Minimum cost = ", show(total_cost), "\n",
  "Shipments x[i,j] (from i to j):\n",
  concat([ concat([ if j == n then show(x[i,j]) ++ "\n" else show(x[i,j]) ++ " " endif
                   | j in CITIES ])
          | i in CITIES ])
];
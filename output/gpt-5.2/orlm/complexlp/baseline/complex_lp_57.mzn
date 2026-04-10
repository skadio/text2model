int: N = 6;
set of int: CITIES = 1..N;

array[CITIES] of int: supply = [255, 250, 314, 8, 385, 440];
array[CITIES] of int: demand = [251, 200, 366, 114, 59, 287];

array[CITIES, CITIES] of int: cost =
[
  % to:  1   2   3   4   5   6
        [0, 26, 39, 13, 37, 28], % from 1
        [36, 0, 48, 5, 22, 14],  % from 2
        [38, 36, 0, 12, 45, 36], % from 3
        [32, 18, 47, 0, 7, 9],   % from 4
        [18, 6, 12, 20, 0, 42],  % from 5
        [4, 28, 42, 43, 7, 0]    % from 6
];

% feasibility check: total supply must cover total demand
constraint sum(i in CITIES)(supply[i]) >= sum(i in CITIES)(demand[i]);

% x[i,j] = amount shipped from city i to city j
array[CITIES, CITIES] of var 0..max(supply): x;

% no self-shipment (optional)
constraint forall(i in CITIES)(x[i,i] = 0);

% outflow from each city cannot exceed its supply
constraint forall(i in CITIES)(
  sum(j in CITIES)(x[i,j]) <= supply[i]
);

% each city's final amount (supply - out + in) must meet demand
constraint forall(i in CITIES)(
  supply[i] - sum(j in CITIES)(x[i,j]) + sum(j in CITIES)(x[j,i]) >= demand[i]
);

var int: total_cost = sum(i,j in CITIES)(cost[i,j] * x[i,j]);

solve minimize total_cost;

output [
  "Minimum cost = ", show(total_cost), "\n",
  "Shipments x[i,j] (from i to j):\n"
] ++
[
  if i=1 then "" else "" endif ++
  concat([ if j=1 then "" else "" endif ++ show(x[i,j]) ++ (if j<N then " " else "\n" endif)
         | j in CITIES ])
| i in CITIES
];
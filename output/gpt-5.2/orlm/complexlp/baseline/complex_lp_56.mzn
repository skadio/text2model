% Resource redistribution / transportation problem (embedded data)

int: n = 5;
set of int: CITIES = 1..n;

array[CITIES] of int: supply = [221, 98, 337, 425, 250];
array[CITIES] of int: demand = [128, 317, 394, 108, 101];

array[CITIES, CITIES] of int: cost =
[
  % to:   1   2   3   4   5
        [ 0, 20, 39,  4, 45], % from 1
        [ 1,  0,  8, 23, 44], % from 2
        [ 5, 46,  0, 36, 15], % from 3
        [ 3,  5, 10,  0, 27], % from 4
        [37, 15,  7, 45,  0]  % from 5
];

int: total_supply = sum(i in CITIES)(supply[i]);
int: total_demand = sum(i in CITIES)(demand[i]);
constraint total_supply >= total_demand;

% x[i,j] = units shipped from city i to city j
array[CITIES, CITIES] of var 0..total_supply: x;

% Shipments out of each city cannot exceed its initial supply
constraint forall(i in CITIES)(
  sum(j in CITIES)(x[i,j]) <= supply[i]
);

% Each city's final amount: supply + inflow - outflow must meet demand
constraint forall(j in CITIES)(
  supply[j] + sum(i in CITIES)(x[i,j]) - sum(k in CITIES)(x[j,k]) >= demand[j]
);

var int: total_cost = sum(i in CITIES, j in CITIES)(cost[i,j] * x[i,j]);

solve minimize total_cost;

output [
  "Minimum cost = ", show(total_cost), "\n",
  "Shipments (from i to j):\n",
  concat([ concat([ if j=1 then "" else "" endif ++
                    "x[" ++ show(i) ++ "," ++ show(j) ++ "]=" ++ show(x[i,j]) ++
                    (if j==n then "\n" else "  " endif)
                  | j in CITIES ])
         | i in CITIES ])
];
include "globals.mzn";

% Cities: 1=Alpha, 2=Bravo, 3=Charlie, 4=Delta
int: n = 4;
set of int: CITIES = 1..n;

% Delivery costs (symmetric as given)
array[CITIES, CITIES] of int: cost =
  [|  0, 41, 55, 22
   | 41,  0, 47, 47
   | 55, 47,  0, 35
   | 22, 47, 35,  0 |];

% next_city[i] = city visited immediately after i in the tour
array[CITIES] of var CITIES: next_city;

% One outgoing arc from each city, and all successors are distinct (a permutation)
constraint all_different(next_city);

% No self loops
constraint forall(i in CITIES)(next_city[i] != i);

% Ensure it is a single Hamiltonian cycle (not multiple smaller cycles)
array[CITIES] of var CITIES: pos;
constraint all_different(pos);
constraint pos[1] = 1; % fix a representative start to remove rotational symmetry
constraint forall(i in CITIES)(
  pos[next_city[i]] = if pos[i] = n then 1 else pos[i] + 1 endif
);

% Objective: total cost of the cycle
var int: total_cost = sum(i in CITIES)( cost[i, next_city[i]] );

solve minimize total_cost;

function string: cityName(int: c) =
  if c = 1 then "Alpha"
  elseif c = 2 then "Bravo"
  elseif c = 3 then "Charlie"
  else "Delta"
  endif;

output [
  "Minimum total delivery cost = ", show(total_cost), "\n",
  "Next city mapping:\n"
] ++
[
  cityName(i) ++ " -> " ++ cityName(fix(next_city[i])) ++ "\n"
  | i in CITIES
];
% Traveling Salesperson Problem (5 cities) - embedded data

int: nCities = 5;
set of int: CITIES = 1..nCities;

% Travel cost matrix (0 on diagonal)
array[CITIES, CITIES] of int: cost =
[|  0, 40, 40, 56, 93
 | 40,  0, 52, 71, 90
 | 40, 52,  0, 57, 14
 | 56, 71, 57,  0, 13
 | 93, 90, 14, 13,  0
 |];

int: maxCost = max([cost[i,j] | i in CITIES, j in CITIES]);
int: maxTourCost = nCities * maxCost;

array[CITIES] of var CITIES: next;        % successor city
var 0..maxTourCost: totalCost;

constraint circuit(next);

constraint totalCost = sum(i in CITIES)(cost[i, next[i]]);

solve minimize totalCost;

output [
  "totalCost = ", show(totalCost), "\n",
  "next = ", show(next), "\n"
];
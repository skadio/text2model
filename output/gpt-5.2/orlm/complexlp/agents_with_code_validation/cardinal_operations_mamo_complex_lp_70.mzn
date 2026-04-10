include "globals.mzn";

% Parameters
int: nCities = 4;
set of int: Cities = 1..nCities;

array[Cities, Cities] of int: cost =
  [|  0, 61, 17, 81
   | 61,  0, 40, 52
   | 17, 40,  0, 23
   | 81, 52, 23,  0 |];

set of int: Positions = 1..nCities;

% Variables
array[Positions] of var Cities: tour;          % city at each position in the cycle
array[Cities, Cities] of var 0..1: arc;        % selected directed arcs
var int: totalCost;

% Constraints

% Visit each city exactly once
constraint all_different(tour);

% Disallow self-loops
constraint forall(i in Cities)(arc[i,i] = 0);

% Link tour positions to arc variables (successive moves + return)
constraint forall(p in 1..nCities-1)(
  arc[tour[p], tour[p+1]] = 1
);
constraint arc[tour[nCities], tour[1]] = 1;

% Each city has exactly one outgoing and one incoming arc
constraint forall(i in Cities)(sum(j in Cities)(arc[i,j]) = 1);
constraint forall(j in Cities)(sum(i in Cities)(arc[i,j]) = 1);

% Prevent extra arcs beyond those implied by the tour
constraint forall(i in Cities, j in Cities where i != j)(
  arc[i,j] <=
    sum(p in 1..nCities-1)(bool2int(tour[p] = i /\ tour[p+1] = j))
    + bool2int(tour[nCities] = i /\ tour[1] = j)
);

% Total cost
constraint totalCost = sum(i in Cities, j in Cities)(cost[i,j] * arc[i,j]);

solve minimize totalCost;

output [
  "tour = ", show(tour), "\n",
  "totalCost = ", show(totalCost), "\n"
];
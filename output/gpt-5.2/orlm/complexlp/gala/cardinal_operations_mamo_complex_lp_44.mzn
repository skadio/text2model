include "globals.mzn";

% Transportation problem: ship supplies from regions with surplus to regions with deficit
% to meet all demands at minimum cost.

int: n = 7;
set of int: R = 1..n;

array[R] of int: supply = [318, 349, 129, 381, 430,  52, 124];
array[R] of int: demand = [309,   9, 279,  71, 365, 233, 483];

array[R, R] of int: cost =
[| 0,  2, 26, 19, 16, 26, 36
 | 27, 0, 26,  4, 15, 43, 25
 | 17,45,  0, 18, 36, 37, 39
 | 19,16, 14,  0,  5, 35,  9
 | 44,47,  4,  3,  0,  2,  4
 | 30,12, 28, 10, 16,  0, 25
 | 19,16, 10,  2, 50,  4,  0 |];

int: totalSupply = sum(r in R)(supply[r]);
int: totalDemand = sum(r in R)(demand[r]);

% Total supply is insufficient; allow importing external supply at a high penalty cost.
% Add a dummy source 0 with supply = totalDemand - totalSupply, shipping to any region with penalty.
int: shortage = totalDemand - totalSupply;
int: bigM = 1000; % penalty per unit imported

% Decision variables: x[i,j] shipped from i to j (i in 0..n, j in 1..n)
array[0..n, R] of var 0..totalDemand: x;

% Costs including dummy source 0
array[0..n, R] of int: cost2 =
array2d(0..n, R,
  [ if i = 0 then bigM else cost[i,j] endif | i in 0..n, j in R ]
);

% Supply constraints for real regions
constraint forall(i in R)(
  sum(j in R)(x[i,j]) <= supply[i]
);

% Dummy source provides exactly the shortage (if any)
constraint sum(j in R)(x[0,j]) = shortage;

% Demand satisfaction
constraint forall(j in R)(
  sum(i in 0..n)(x[i,j]) >= demand[j]
);

% No self-shipping for real regions (optional tightening)
constraint forall(i in R)( x[i,i] = 0 );

var int: totalCost = sum(i in 0..n, j in R)( cost2[i,j] * x[i,j] );

solve minimize totalCost;

output [
  "TotalSupply = ", show(totalSupply), "\n",
  "TotalDemand = ", show(totalDemand), "\n",
  "Shortage(imported) = ", show(shortage), "\n",
  "TotalCost = ", show(totalCost), "\n\n",
  "Shipments x[i,j] (i=0 is external source):\n",
  concat([ concat([ "x[", show(i), ",", show(j), "]=", show(x[i,j]), if j=n then "\n" else "  " endif
                  | j in R ])
         | i in 0..n ])
];
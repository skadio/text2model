include "globals.mzn";

% Parameters
int: nCities = 4;
set of int: Cities = 1..nCities;   % 1=A, 2=B, 3=C, 4=D

array[Cities, Cities] of int: cost =
  [|  0, 19, 45, 30
   | 19,  0, 89, 46
   | 45, 89,  0, 11
   | 30, 46, 11,  0 |];

int: minCost = 0;
int: maxCost = 89;

% Variables
array[Cities] of var Cities: succ;            % successor city
array[Cities] of var 1..nCities: pos;         % position in tour (subtour elimination)
var minCost..(nCities * maxCost): totalCost;

% Constraints
constraint forall(i in Cities)(cost[i,i] = 0);
constraint forall(i,j in Cities)(cost[i,j] >= minCost /\ cost[i,j] <= maxCost);

% Cost of chosen arcs
constraint totalCost = sum(i in Cities)(cost[i, succ[i]]);

% succ is a permutation -> each city has exactly one incoming and one outgoing arc
constraint all_different(succ);

% Subtour elimination (MTZ-like) using positions
constraint pos[1] = 1;
constraint all_different(pos);

constraint
  forall(i in Cities)(
    let { var int: j = succ[i] } in
      (pos[i] < nCities -> pos[j] = pos[i] + 1) /\
      (pos[i] = nCities -> pos[j] = 1)
  );

solve minimize totalCost;

output [
  "totalCost = ", show(totalCost), "\n",
  "succ = ", show(succ), "\n",
  "pos = ", show(pos), "\n"
];
% Freight car relocation (min-cost flow) among 5 regions
% Data embedded per problem statement

int: N = 5;
set of int: LOC = 1..N;

array[LOC] of int: present = [120, 330, 400, 400, 600];
array[LOC] of int: needed  = [150, 200, 600, 200, 400];

% Net supply: positive means surplus (can ship out), negative means deficit (needs inflow)
array[LOC] of int: supply = [present[i] - needed[i] | i in LOC];

% Costs for moving from i to j (only defined for i<j in statement; allow both directions with same cost)
array[LOC, LOC] of int: cost = array2d(LOC, LOC,
[
  % j=1  2   3   4   5
      0,  0, 11, 13, 28, % i=1
      0,  0, 18,  8, 46, % i=2
     11, 18,  0,  9, 27, % i=3
     13,  8,  9,  0, 20, % i=4
     28, 46, 27, 20,  0  % i=5
]);

% Decision variables: number of cars moved from i to j
% Disallow i=j by fixing to 0
array[LOC, LOC] of var 0..10000: x;
constraint forall(i in LOC) (x[i,i] = 0);

% Flow balance at each location:
% outflow - inflow = supply
constraint
  forall(i in LOC) (
    sum(j in LOC)(x[i,j]) - sum(j in LOC)(x[j,i]) = supply[i]
  );

var int: total_cost = sum(i in LOC, j in LOC)(cost[i,j] * x[i,j]);

solve minimize total_cost;

output [
  "Minimum total cost (rounded to nearest dollar): ", show(total_cost), "\n",
  "Shipments x[i,j] (cars moved from i to j):\n"
] ++
[
  if i != j /\ fix(x[i,j]) > 0 then
    "  " ++ show(i) ++ " -> " ++ show(j) ++ ": " ++ show(x[i,j]) ++ "\n"
  else
    ""
  endif
  | i in LOC, j in LOC
];
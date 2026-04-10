% Transportation / redistribution among 7 distribution centers
% Minimize total transfer cost while meeting each center's final requirement.

int: N = 7;
set of int: C = 1..N;

array[C] of int: supply = [97, 458, 473, 380, 34, 399, 163];
array[C] of int: demand  = [119, 275, 36, 459, 17, 128, 425];

% Cost matrix (cost[i,j] = cost to ship from i to j). Diagonal is 0.
array[C, C] of int: cost =
[
|  0, 41, 42, 31, 39,  2, 18 |
| 48,  0,  9, 22, 47, 29, 39 |
| 36, 22,  0, 29, 45, 33, 45 |
| 19,  5, 10,  0,  3, 42, 20 |
| 13, 10, 21,  7,  0, 35, 11 |
|  5, 35, 29, 16, 40,  0,  9 |
|  7, 24, 26, 38, 33, 13,  0 |
];

% Decision variables: shipped units from i to j (nonnegative integers).
array[C, C] of var 0..sum(supply): x;

% No self-shipping
constraint forall(i in C) ( x[i,i] = 0 );

% Flow balance: outgoing from i reduces its supply, incoming increases it.
% Final at each node must equal demand.
constraint forall(i in C) (
    supply[i] - sum(j in C)(x[i,j]) + sum(j in C)(x[j,i]) = demand[i]
);

var int: total_cost = sum(i in C, j in C)( cost[i,j] * x[i,j] );

solve minimize total_cost;

output [
  "Minimum total cost = ", show(total_cost), "\n",
  "Shipment matrix x[i,j] (units from i to j):\n",
  concat([ concat([ (if j=1 then "" else " " endif) ++ show(x[i,j]) | j in C ]) ++ "\n" | i in C ])
];
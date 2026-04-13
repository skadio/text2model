% Medical supplies redistribution (minimum cost flow / transportation)

int: n = 7;
set of int: F = 1..n;

array[F] of int: initial = [229,345,231,164,354,437,265];
array[F] of int: required = [158,14,326,432,207,215,233];

array[F,F] of int: cost =
[
 % to:   1  2  3  4  5  6  7
        [0,26, 8, 7,34,35,34], % from 1
        [41,0,27,31, 3,33,36], % from 2
        [20,49,0,48,21,38,42], % from 3
        [10,35,26,0,21,33,31], % from 4
        [21,30,24,25,0, 5, 8], % from 5
        [27,34,34,26,27,0,43], % from 6
        [38,20,11,43,49, 9,0]  % from 7
];

array[F] of int: balance = [ initial[i] - required[i] | i in F ];

% Feasibility check: total supply must equal total demand
constraint sum(i in F)(balance[i]) = 0;

int: total_supply = sum(i in F where balance[i] > 0)(balance[i]);

array[F,F] of var 0..total_supply: x; % x[i,j] shipped from i to j

% No self-shipping
constraint forall(i in F)(x[i,i] = 0);

% Flow conservation: outgoing - incoming = balance
constraint
  forall(i in F)(
    sum(j in F)(x[i,j]) - sum(j in F)(x[j,i]) = balance[i]
  );

var int: total_cost = sum(i in F, j in F)(cost[i,j] * x[i,j]);

solve minimize total_cost;

output [
  "Minimum total cost = ", show(total_cost), "\n",
  "Shipments (from,to,amount):\n",
  concat([ if fix(x[i,j]) > 0 then
             "  (" ++ show(i) ++ "," ++ show(j) ++ "): " ++ show(x[i,j]) ++ "\n"
           else "" endif
           | i in F, j in F ])
];
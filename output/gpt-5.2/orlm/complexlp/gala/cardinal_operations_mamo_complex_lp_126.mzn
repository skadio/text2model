include "globals.mzn";

% Max-flow from source 0 to sink 7 in a directed capacitated network
int: n = 8;
set of int: V = 0..n-1;
int: s = 0;
int: t = 7;

% Capacity matrix (0 means no arc)
array[V, V] of int: cap =
[| 0, 19,  5,  7,  0, 17, 19,  9
 | 6,  0, 15, 15, 16,  8,  5,  0
 | 5,  6,  0,  3, 10,  7,  6,  3
 | 8,  2,  6,  0,  5, 17,  0,  1
 |17,  4, 10, 10,  0,  6, 15, 14
 |11, 11,  9,  7,  7,  0, 16, 19
 |13, 19, 14, 14, 16,  1,  0, 16
 | 0, 14,  0, 17,  1,  7,  9,  0 |];

% Flow variables on all ordered pairs; constrained to 0 if no arc
int: U = max([cap[i,j] | i in V, j in V]);  % overall upper bound
array[V, V] of var 0..U: f;

% Capacity constraints / forbid flow where no arc exists
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation at intermediate nodes
constraint forall(v in V where v != s /\ v != t) (
  sum(j in V)(f[v,j]) = sum(i in V)(f[i,v])
);

% Define total flow value (out of source == into sink at optimum under conservation)
var 0..sum(j in V)(cap[s,j]): flow_value;
constraint flow_value = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

% Also enforce consistency with sink (redundant but helps)
constraint flow_value = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

solve maximize flow_value;

output [
  "Maximum flow from ", show(s), " to ", show(t), " = ", show(flow_value), "\n",
  "Flow matrix f[i,j]:\n",
  concat([ concat([ if j==0 then "" else " " endif ++ show(f[i,j])
                    | j in V ]) ++ "\n"
          | i in V ])
];
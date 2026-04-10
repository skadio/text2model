% Resource redistribution / transportation problem (balanced flow)
% Data embedded directly as requested.

int: N = 6;
set of int: R = 1..N;

array[R] of int: stock  = [319, 281, 247, 237,  29, 453];
array[R] of int: need   = [243, 243, 124, 202,  84,  28];

% Cost to ship 1 unit from i to j (0 on diagonal; not used)
array[R,R] of int: cost = array2d(R,R,[
  0, 11, 30, 12, 48, 23,
  1,  0, 27,  9, 26, 13,
 29,  6,  0, 27, 13, 44,
  6, 50, 12,  0, 19, 32,
 26, 13, 29,  2,  0, 24,
  9, 26,  2, 37, 22,  0
]);

% Net surplus at each region (positive = supply, negative = demand)
array[R] of int: b = [ stock[i] - need[i] | i in R ];

constraint sum(i in R)(b[i]) = 0; % must be balanced

int: TotalMove = sum(i in R where b[i] > 0)(b[i]);

% x[i,j] = units shipped from i to j
array[R,R] of var 0..TotalMove: x;

% No self-shipping
constraint forall(i in R)(x[i,i] = 0);

% Flow conservation with supplies/demands:
% out - in = surplus (positive supply, negative demand)
constraint forall(i in R)(
  sum(j in R)(x[i,j]) - sum(j in R)(x[j,i]) = b[i]
);

var int: total_cost = sum(i in R, j in R)(cost[i,j] * x[i,j]);

solve minimize total_cost;

output [
  "Minimum cost = ", show(total_cost), "\n",
  "Shipments (i->j : amount):\n",
  concat([ if fix(x[i,j]) > 0 then
             show(i) ++ "->" ++ show(j) ++ " : " ++ show(x[i,j]) ++ "\n"
           else "" endif
         | i in R, j in R ])
];
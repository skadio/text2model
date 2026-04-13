% Medical supplies redistribution (min cost flow)
% Data embedded as requested

int: N = 7;
set of int: H = 1..N;

array[H] of int: stock = [160, 353, 171, 193, 102, 429, 284];
array[H] of int: req   = [ 19, 138, 110, 446, 341, 428,  47];

array[H, H] of int: cost =
[|  0, 12, 47, 39,  4, 21, 31
 | 14,  0, 39, 12, 31, 29, 15
 | 15,  6,  0, 26, 12,  5,  3
 | 39, 47, 42,  0, 33, 48,  2
 | 35, 25, 46, 12,  0, 25, 45
 | 39, 28, 28, 11, 16,  0, 13
 | 42, 43, 49, 41, 41, 18,  0 |];

% Derived parameters
array[H] of int: surplus = [stock[h] - req[h] | h in H];
int: S = sum(h in H)(max(0, surplus[h]));  % total shippable surplus
int: max_c = max(i in H, j in H)(cost[i,j]);

% Decision variables: ship only out of surplus nodes into deficit nodes (others fixed to 0)
array[H, H] of var 0..S: x;

% Structural zeros to reduce search and avoid huge domains
constraint forall(i in H)( x[i,i] = 0 );
constraint forall(i in H, j in H where surplus[i] <= 0)( x[i,j] = 0 );
constraint forall(i in H, j in H where surplus[j] >= 0)( x[i,j] = 0 );

% Balance constraints:
% - surplus hospitals: cannot send more than their surplus (and they should not receive)
constraint forall(i in H where surplus[i] > 0)(
  sum(j in H)(x[i,j]) <= surplus[i]
);
constraint forall(i in H where surplus[i] > 0)(
  sum(j in H)(x[j,i]) = 0
);

% - deficit hospitals: must receive exactly their deficit (and they should not send)
constraint forall(j in H where surplus[j] < 0)(
  sum(i in H)(x[i,j]) = -surplus[j]
);
constraint forall(j in H where surplus[j] < 0)(
  sum(k in H)(x[j,k]) = 0
);

% Objective
var 0..(S * max_c): total_cost =
  sum(i in H, j in H)(cost[i,j] * x[i,j]);

solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n"
];
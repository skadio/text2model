% Max flow from source s to sink t with given capacities (embedded data)

int: N = 7;
set of int: V = 0..N-1;
int: s = 0;
int: t = 6;

array[V, V] of int: cap =
  array2d(V, V,
    [ 0,16, 6,16, 2,17,15,
      7, 0,13, 3, 0, 8,17,
      3,17, 0,18,11,18,11,
      9, 0,15, 0, 3, 8,10,
      3, 6, 1,16, 0,13,10,
     15,20, 2, 6,18, 0, 9,
      4, 6, 8,13,16,10, 0 ]);

int: maxCap = max([cap[i,j] | i in V, j in V]);

array[V, V] of var 0..maxCap: f;

var 0..sum(j in V)(cap[s,j]): F;

constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

constraint forall(i in V) (
  sum(j in V)(f[i,j]) - sum(j in V)(f[j,i]) =
    if i == s then F
    elseif i == t then -F
    else 0 endif
);

solve maximize F;

output ["Max flow F = ", show(F), "\n"];
% Maximum flow from Reservoir 0 (source) to Reservoir 8 (sink)

int: N = 9;
set of int: V = 0..N-1;
int: s = 0;
int: t = 8;

array[V, V] of int: cap =
array2d(V, V,
[
% to:  0  1  2  3  4  5  6  7  8
       0, 6, 1,14,20, 6,13,13,15,  % from 0
       2, 0, 5, 5,13, 5,12, 9,15,  % from 1
      15, 0, 0, 8,16, 9,19,15, 6,  % from 2
      13, 8, 0, 0,14,12, 9, 1, 2,  % from 3
       4,14,19,16, 0,14,11,11, 2,  % from 4
      19,18, 5,20, 9, 0,11, 5, 7,  % from 5
      11,14,20,17,11,13, 0,11,16,  % from 6
       6, 2,17, 0,10,13,17, 0, 9,  % from 7
       8, 9, 7,18,12,13, 5, 9, 0   % from 8
]);

array[V, V] of var 0..20: f;

constraint
  forall(i in V, j in V) (
    f[i,j] <= cap[i,j]
  );

% Flow conservation at intermediate nodes
constraint
  forall(k in V where k != s /\ k != t) (
    sum(i in V)(f[i,k]) = sum(j in V)(f[k,j])
  );

var int: maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

solve maximize maxflow;

output [
  "Maximum transferable water (million gallons/day): ", show(maxflow), "\n"
];
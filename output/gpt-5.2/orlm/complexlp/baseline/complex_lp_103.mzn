% Maximum flow from source (0) to sink (7) with embedded data

int: N = 8;
set of int: V = 0..N-1;
int: s = 0;
int: t = 7;

array[V,V] of int: cap =
%      to:  0  1  2  3  4  5  6  7
array2d(V,V,[
/*0*/   0,11, 1, 6, 4, 5, 7, 1,
/*1*/   3, 0,15,15,16, 9,14,12,
/*2*/  19, 9, 0, 5, 9,11,16, 3,
/*3*/  15, 1,14, 0, 0, 4, 1,15,
/*4*/   8,16, 7, 3, 0,16,10,11,
/*5*/   7, 8, 1,11,19, 0, 3, 3,
/*6*/   2,19, 2, 6,12,20, 0, 6,
/*7*/  15,17, 4, 7, 8, 2,16, 0
]);

array[V,V] of var 0..max(cap): f;

constraint
  forall(i in V, j in V) (
    f[i,j] <= cap[i,j]
  );

% flow conservation for intermediate nodes
constraint
  forall(k in V where k != s /\ k != t) (
    sum(i in V)(f[i,k]) = sum(j in V)(f[k,j])
  );

var int: flow_value = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

solve maximize flow_value;

output [
  "Max flow (tons/day) = ", show(flow_value), "\n"
];
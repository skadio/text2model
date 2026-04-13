% Parameters (with values embedded)
int: N = 8;
set of int: V = 0..N-1;
int: s = 0;
int: t = 7;

array[V, V] of int: cap =
%      to:  0  1  2  3  4  5  6  7
array2d(V, V, [
/*0*/       0, 3, 7, 2,18,18,14,10,
/*1*/       1, 0,10,16,14, 0, 6,10,
/*2*/       4, 0, 0, 7, 2, 2, 6,10,
/*3*/       2, 3, 7, 0,20, 8, 6,10,
/*4*/       1,20, 4, 8, 0,13, 8, 1,
/*5*/      16, 9,17,17,11, 0, 7, 8,
/*6*/       3, 7,14, 1,20, 5, 0,13,
/*7*/       3, 6, 5, 1,14,20, 9, 0
]);

int: maxCap = max([cap[i,j] | i in V, j in V]);

% Variables
array[V, V] of var 0..maxCap: f;     % flow on arc i->j
var 0..sum(j in V)(cap[s,j]): F;      % total s->t flow value

% Constraints
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation (excluding source and sink)
constraint forall(v in V where v != s /\ v != t) (
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

% Define objective flow value from source (equivalently into sink)
constraint F = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);
constraint F = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize F;

output ["Optimal max goods (thousands of units) = ", show(F), "\n"];
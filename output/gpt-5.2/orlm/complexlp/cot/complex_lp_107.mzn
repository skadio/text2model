% Parameters (with values embedded)
int: N = 7;
set of int: V = 0..N-1;
int: s = 0;
int: t = 6;

array[V, V] of int: cap =
%      to:  0   1   2   3   4   5   6
array2d(V, V, [
/*0*/      0, 17,  3, 20, 11, 11,  3,
/*1*/     11,  0, 12, 18,  5,  6,  4,
/*2*/      7,  2,  0, 15, 13, 20, 18,
/*3*/      7,  4,  2,  0,  2, 15,  3,
/*4*/     19, 12, 16,  4,  0, 19,  4,
/*5*/     13, 20, 10, 14, 15,  0,  1,
/*6*/      3,  3,  6, 20,  9, 10,  0
]);

int: maxCap = max([cap[i,j] | i in V, j in V]);

% Variables
array[V, V] of var 0..maxCap: f;        % flow on arc (i,j)
var 0..(maxCap * (N-1)): F;             % total s->t flow value (upper bound: out of s)

% Constraints
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation
constraint forall(v in V where v != s /\ v != t) (
  sum(j in V)(f[v,j]) = sum(i in V)(f[i,v])
);

% Define objective flow value as net outflow from source (equivalently net inflow to sink)
constraint F = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

% Objective
solve maximize F;

output ["Max flow (TB per hour) = \(F)\n"];
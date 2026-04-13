% Parameters (with values embedded)
int: N = 7;
set of int: V = 0..N-1;
int: s = 0;
int: t = 6;

array[V, V] of int: cap =
[
% to:   0  1  2  3  4  5  6
/*0*/ [ 0,18, 2,10,17, 0,12],
/*1*/ [14, 0, 3, 1,19,18, 2],
/*2*/ [17, 5, 0,15,15,19, 0],
/*3*/ [14,17, 0, 0,19, 9,16],
/*4*/ [ 2,13,15,12, 0,20, 5],
/*5*/ [ 9,16, 4,15,15, 0,11],
/*6*/ [ 8,10,19,19,17,16, 0]
];

int: U = max([cap[i,j] | i in V, j in V]);

% Variables
array[V, V] of var 0..U: f;           % flow on arc i->j
var 0..(sum(j in V)(cap[s,j])): F;     % total s->t flow value (bounded by out of source)

% Constraints
% Capacity constraints (including forcing f=0 where cap=0)
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation at intermediate nodes
constraint forall(v in V where v != s /\ v != t) (
  sum(u in V)(f[u,v]) = sum(w in V)(f[v,w])
);

% Define total flow as net outflow of source (equivalently net inflow to sink)
constraint F = sum(j in V)(f[s,j]) - sum(j in V)(f[j,s]);

% Ensure sink has matching net inflow
constraint F = sum(i in V)(f[i,t]) - sum(i in V)(f[t,i]);

% Objective
solve maximize F;

output [
  "Maximum flow (Tbps) = ", show(F), "\n"
];
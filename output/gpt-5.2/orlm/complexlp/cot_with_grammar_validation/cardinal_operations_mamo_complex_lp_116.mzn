% Parameters
int: N = 9;
set of int: V = 0..N-1;
int: s = 0;
int: t = 8;

array[V, V] of int: cap =
array2d(V, V,
% to:    0  1  2  3  4  5  6  7  8
[
/*0*/    0,11,11,14, 6,11, 4,15, 9,
/*1*/    0, 0,20,12, 4, 7, 8, 9, 3,
/*2*/    0,18, 0,10, 2,18, 6, 5, 1,
/*3*/    0, 3, 7, 0,20, 9, 2, 4, 6,
/*4*/    0, 5, 8, 1, 0,11,14, 3, 7,
/*5*/    0, 9, 4, 6,13, 0,20, 2,10,
/*6*/    0, 2,12, 8, 5, 7, 0,20,11,
/*7*/    0, 4, 3,15, 9, 1, 6, 0,20,
/*8*/    0, 6, 2, 4, 7, 5, 9, 8, 0
]);

int: maxCap = max([cap[i,j] | i in V, j in V]);

% Variables
array[V, V] of var 0..maxCap: f;
var 0..(maxCap * N): flow;

% Constraints
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

constraint forall(i in V) (
  if i != s /\ i != t then
    sum(j in V)(f[i,j]) = sum(j in V)(f[j,i])
  else
    true
  endif
);

constraint flow = sum(j in V)(f[s,j]) - sum(j in V)(f[j,s]);

constraint flow = sum(j in V)(f[j,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize flow;
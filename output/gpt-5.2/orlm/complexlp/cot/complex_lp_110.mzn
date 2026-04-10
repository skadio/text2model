% Parameters (with values embedded)
int: N = 6;
set of int: Cities = 0..N-1;
int: source = 0;
int: sink = 5;

array[Cities, Cities] of int: cap =
%        to: 0  1  2  3  4  5
array2d(Cities, Cities, [
/*0*/      0, 6, 8, 1, 9, 8,
/*1*/     16, 0, 6, 0,12,16,
/*2*/      7,16, 0,20,17, 9,
/*3*/      3,11,14, 0, 7, 0,
/*4*/      6,19,19, 3, 0,20,
/*5*/     20, 5,16,12, 2, 0
]);

int: maxCap = max([cap[i,j] | i in Cities, j in Cities]);

% Variables
array[Cities, Cities] of var 0..maxCap: f;
var 0..(sum(j in Cities)(cap[source,j])): total_flow;

% Constraints
constraint forall(i in Cities, j in Cities) (
  f[i,j] <= cap[i,j]
);

constraint forall(v in Cities where v != source /\ v != sink) (
  sum(i in Cities)(f[i,v]) = sum(j in Cities)(f[v,j])
);

constraint total_flow = sum(j in Cities)(f[source,j]) - sum(i in Cities)(f[i,source]);

constraint total_flow = sum(i in Cities)(f[i,sink]) - sum(j in Cities)(f[sink,j]);

% Objective
solve maximize total_flow;
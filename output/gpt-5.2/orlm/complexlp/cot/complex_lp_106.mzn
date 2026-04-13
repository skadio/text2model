% Parameters (with values embedded)
int: N = 9;
set of int: Cities = 0..N-1;
int: Source = 0;
int: Sink = 8;

array[Cities, Cities] of int: cap =
array2d(Cities, Cities,
[
  0, 15, 12,  9,  7, 12,  5, 20, 10,
  6,  0,  8,  0, 19, 14, 17,  9, 16,
 19, 11,  0,  0, 13, 14, 17, 10, 13,
 15,  4,  5,  0,  2, 18,  6, 17, 19,
  2,  8,  2,  4,  0,  6, 14, 20, 18,
 14,  9, 18,  7,  4,  0, 11, 11, 13,
 12, 14, 12,  4, 18,  6,  0,  5,  4,
 20,  1,  6, 17,  4,  2, 11,  0,  9,
 16,  6, 14,  0, 17, 17,  6,  9,  0
]);

int: maxCap = max([cap[i,j] | i in Cities, j in Cities]);
int: UB = maxCap * (N-1); % safe upper bound on any single arc flow

% Variables
array[Cities, Cities] of var 0..UB: f;   % flow on directed arc i->j
var 0..UB: totalFlow;

% Constraints
% Respect capacities (including cap=0 implies no flow)
constraint forall(i in Cities, j in Cities) (
  f[i,j] <= cap[i,j]
);

% Flow conservation
constraint
  totalFlow = sum(j in Cities where j != Source)(f[Source,j]) - sum(i in Cities where i != Source)(f[i,Source]);

constraint forall(k in Cities where k != Source /\ k != Sink) (
  sum(i in Cities where i != k)(f[i,k]) = sum(j in Cities where j != k)(f[k,j])
);

constraint
  sum(i in Cities where i != Sink)(f[i,Sink]) - sum(j in Cities where j != Sink)(f[Sink,j]) = totalFlow;

% Objective
solve maximize totalFlow;
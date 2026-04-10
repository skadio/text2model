% Parameters
int: N = 5; % batches
int: M = 3; % vats (machines)
set of int: B = 1..N;
set of int: V = 1..M;

% Processing times in hours (scaled by 10 to make integers)
int: SCALE = 10;
array[B, V] of int: p = array2d(B, V,
[
  30, 10, 10,
  20, 15, 10,
  30, 12, 13,
  20, 20, 20,
  21, 20, 30
]);

% Upper bound on makespan (sum of all processing times)
int: UB = sum(b in B, v in V)(p[b,v]);

% Variables
array[B, V] of var 0..UB: s; % start times (scaled)
array[B, V] of var 0..UB: e; % end times (scaled)
var 0..UB: makespan;

% Constraints
constraint
  forall(b in B, v in V)(
    e[b,v] = s[b,v] + p[b,v]
  );

% Each batch must go through vats in order: 1 -> 2 -> 3
constraint
  forall(b in B, v in 1..M-1)(
    s[b, v+1] >= e[b, v]
  );

% No overlap on each vat (machine capacity 1)
constraint
  forall(v in V, b1 in B, b2 in B where b1 < b2)(
    s[b1,v] >= e[b2,v] \/ s[b2,v] >= e[b1,v]
  );

% Makespan definition
constraint
  forall(b in B)(
    makespan >= e[b, M]
  );

% Objective
solve minimize makespan;
% Parameters
int: N = 7;
set of int: ACT = 1..N;

% Activity indices
int: A = 1;
int: B = 2;
int: C = 3;
int: D = 4;
int: E = 5;
int: F = 6;
int: G = 7;

array[ACT] of int: dur = [4, 3, 5, 2, 10, 10, 1];

% Costs
int: work_cost_per_day = 1000;
int: machine_cost_per_day = 5000;

% Precedence arcs (u -> v means start[v] >= start[u] + dur[u])
int: P = 7;
set of int: ARC = 1..P;
array[ARC] of int: pred = [A, A, E, G, D, F, F];
array[ARC] of int: succ = [G, D, F, F, C, C, B];

% Variables
int: UB = sum(i in ACT)(dur[i]);
array[ACT] of var 0..UB: s;         % start times
array[ACT] of var 0..UB: e;         % end times
var 0..UB: makespan;
var 0..UB: machine_span;            % from start(A) to end(B)
var 0..(work_cost_per_day*UB*N + machine_cost_per_day*UB): total_cost;

% Constraints
constraint forall(i in ACT) (
  e[i] = s[i] + dur[i]
);

constraint forall(k in ARC) (
  s[succ[k]] >= e[pred[k]]
);

constraint makespan >= max(i in ACT)(e[i]);

constraint machine_span = e[B] - s[A];
constraint s[A] = 0;  % project starts with A

constraint total_cost =
  work_cost_per_day * makespan
  + machine_cost_per_day * machine_span;

% Objective
solve minimize total_cost;
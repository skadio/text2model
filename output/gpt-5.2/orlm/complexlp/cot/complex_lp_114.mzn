% Parameters (with values embedded)
int: N = 6;
set of int: CITIES = 0..N-1;
int: source = 0;
int: sink = 5;

array[CITIES, CITIES] of int: cap =
  [|  0,  9, 13,  0, 20, 16
   |  6,  0, 19, 11, 14, 15
   | 11,  6,  0,  8,  3, 10
   | 16,  2, 17,  0,  1, 17
   |  4, 12,  5, 16,  0, 15
   |  7, 19, 18,  6,  8,  0 |];

% Variables
int: U = sum(i in CITIES)(cap[source,i]); % safe upper bound on total flow
array[CITIES, CITIES] of var 0..U: f;     % flow on each directed highway (thousand vehicles/hour)
var 0..U: maxflow;

% Constraints
constraint
  forall(i,j in CITIES) (
    f[i,j] <= cap[i,j]
  );

constraint
  forall(v in CITIES where v != source /\ v != sink) (
    sum(i in CITIES)(f[i,v]) = sum(j in CITIES)(f[v,j])
  );

constraint
  maxflow = sum(j in CITIES)(f[source,j]) - sum(i in CITIES)(f[i,source]);

constraint
  maxflow = sum(i in CITIES)(f[i,sink]) - sum(j in CITIES)(f[sink,j]);

% Objective
solve maximize maxflow;
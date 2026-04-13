% Parameters (with values embedded)
int: N = 6;
set of int: CITIES = 0..N-1;

int: source = 0;
int: sink = 5;

array[CITIES, CITIES] of int: cap =
array2d(CITIES, CITIES,
[
  % to:   0   1   2   3   4   5
          0, 14, 15, 13,  0,  4,   % from 0
         10,  0,  7, 18,  9,  5,   % from 1
         11,  0,  0,  7, 13,  6,   % from 2
          7, 11, 18,  0, 17,  2,   % from 3
         19,  8, 15, 15,  0,  5,   % from 4
         10, 19, 17,  2,  3,  0    % from 5
]);

int: U = sum(i,j in CITIES)(cap[i,j]); % simple safe upper bound on any flow

% Variables
array[CITIES, CITIES] of var 0..U: f;     % flow on each directed highway
var 0..U: maxflow;

% Constraints
constraint
  forall(i,j in CITIES) (
    f[i,j] <= cap[i,j]
  );

% Flow conservation (except at source and sink)
constraint
  forall(v in CITIES where v != source /\ v != sink) (
    sum(u in CITIES)(f[u,v]) = sum(w in CITIES)(f[v,w])
  );

% Define maxflow as net outflow from source (equivalently net inflow to sink)
constraint
  maxflow = sum(w in CITIES)(f[source,w]) - sum(u in CITIES)(f[u,source]);

constraint
  maxflow = sum(u in CITIES)(f[u,sink]) - sum(w in CITIES)(f[sink,w]);

% Objective
solve maximize maxflow;

output [
  "Maximum trucks per hour from city ", show(source), " to city ", show(sink), ": ",
  show(maxflow), "\n"
];
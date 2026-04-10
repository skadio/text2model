% Parameters (with values embedded)
int: N = 6;
set of int: Cities = 0..N-1;
int: source = 0;
int: sink = 5;

array[Cities, Cities] of int: cap =
  [| 0, 17, 14, 13, 11,  3
   | 1,  0, 18, 14, 12, 16
   | 5,  1,  0,  7,  2,  5
   |10, 13, 19,  0,  4, 16
   | 3,  0, 13,  0,  0, 14
   |15, 16,  4,  1, 16,  0 |];

% Variables
array[Cities, Cities] of var 0..19: f;   % flow on each directed track (bounded by max capacity in data)
var 0..114: total_flow;                  % total trains from source to sink (upper bound = sum out of source)

% Constraints
constraint forall(i, j in Cities) (
  f[i,j] <= cap[i,j]
);

% Flow conservation at intermediate cities
constraint forall(v in Cities where v != source /\ v != sink) (
  sum(i in Cities)(f[i,v]) = sum(j in Cities)(f[v,j])
);

% Define total flow as net outflow from source (equivalently net inflow to sink)
constraint total_flow = sum(j in Cities)(f[source,j]) - sum(i in Cities)(f[i,source]);
constraint total_flow = sum(i in Cities)(f[i,sink]) - sum(j in Cities)(f[sink,j]);

% Objective
solve maximize total_flow;
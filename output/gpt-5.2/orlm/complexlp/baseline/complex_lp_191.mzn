% Maximum flow in a directed graph with embedded data

int: N = 4;
set of int: V = 1..N;

int: source = 1;
int: sink = 4;

array[V, V] of int: cap =
array2d(V, V, [
  % to: 1  2  3  4
       0, 8, 7, 0,  % from 1
       0, 0, 2, 4,  % from 2
       0, 0, 0, 7,  % from 3
       0, 0, 0, 0   % from 4
]);

array[V, V] of var 0..max(cap): f;

constraint
  forall(i in V, j in V) (
    f[i,j] <= cap[i,j]
  );

% Flow conservation at intermediate nodes
constraint
  forall(k in V where k != source /\ k != sink) (
    sum(i in V)(f[i,k]) = sum(j in V)(f[k,j])
  );

% Maximize total flow out of source (equivalently into sink by conservation)
var int: maxflow = sum(j in V)(f[source,j]);

solve maximize maxflow;

output [
  "Maximum flow (rounded to nearest integer): ", show(maxflow), "\n",
  "Flow matrix f[i,j]:\n"
] ++
[
  if j = 1 then "from " ++ show(i) ++ ": " else "" endif ++
  show(f[i,j]) ++ if j = N then "\n" else " " endif
  | i in V, j in V
];
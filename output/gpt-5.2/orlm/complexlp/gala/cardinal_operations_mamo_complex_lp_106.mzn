% Max flow from City 0 to City 8 with given arc capacities (0 => no arc)

int: N = 9;
set of int: V = 0..N-1;
int: s = 0;
int: t = 8;

array[V, V] of int: cap =
array2d(V, V,
[
  % to:  0  1  2  3  4  5  6  7  8    from
        0,15,12, 9, 7,12, 5,20,10,   % 0
        6, 0, 8, 0,19,14,17, 9,16,   % 1
       19,11, 0, 0,13,14,17,10,13,   % 2
       15, 4, 5, 0, 2,18, 6,17,19,   % 3
        2, 8, 2, 4, 0, 6,14,20,18,   % 4
       14, 9,18, 7, 4, 0,11,11,13,   % 5
       12,14,12, 4,18, 6, 0, 5, 4,   % 6
       20, 1, 6,17, 4, 2,11, 0, 9,   % 7
       16, 6,14, 0,17,17, 6, 9, 0    % 8
]);

% Flow variables on each directed arc
array[V, V] of var 0..20: f;

% Respect capacities; force zero flow where no arc exists
constraint forall(i,j in V) (
  f[i,j] <= cap[i,j] /\
  (cap[i,j] = 0 -> f[i,j] = 0)
);

% Flow conservation at intermediate nodes
constraint forall(v in V where v != s /\ v != t) (
  sum(j in V)(f[v,j]) = sum(i in V)(f[i,v])
);

% Objective: maximize total flow from source (equivalently into sink)
var 0..200: maxFlow = sum(j in V)(f[s,j]);
constraint maxFlow = sum(i in V)(f[i,t]);

solve maximize maxFlow;

output [
  "Maximum goods transported from City ", show(s), " to City ", show(t), " = ",
  show(maxFlow), " tons\n",
  "Flow matrix f[from,to]:\n",
  show2d(f), "\n"
];
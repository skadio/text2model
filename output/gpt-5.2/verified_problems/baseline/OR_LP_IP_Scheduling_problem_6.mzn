int: n;
int: num_edges;
array[1..num_edges, 1..2] of int: E;   % E[e,1]=from, E[e,2]=to
array[1..num_edges] of int: a;         % capacities
int: s;
int: t;

set of int: N = 1..n;
set of int: A = 1..num_edges;

array[A] of int: u = [E[e,1] | e in A];
array[A] of int: v = [E[e,2] | e in A];

array[A] of var 0..max(a): x;

constraint
  forall(e in A) (
    x[e] <= a[e]
  );

constraint
  forall(i in N where i != s /\ i != t) (
    sum(e in A where v[e] == i)(x[e]) = sum(e in A where u[e] == i)(x[e])
  );

var 0..sum(a): maxflow =
  sum(e in A where u[e] == s)(x[e]) - sum(e in A where v[e] == s)(x[e]);

solve maximize maxflow;

output [
  "maxflow = ", show(maxflow), ";\n",
  "x = [", concat([ if e==1 then "" else ", " endif ++ show(x[e]) | e in A ]), "];\n"
];
int: n;
int: num_edges;
array[1..num_edges, 1..2] of int: E;   % E[e,1]=from, E[e,2]=to
array[1..num_edges] of int: a;         % capacities
int: s;                                % source node (in 1..n)
int: t;                                % sink node (in 1..n)

set of int: N = 1..n;
set of int: EDGES = 1..num_edges;

array[EDGES] of var 0..max(a): flow;

constraint
  forall(e in EDGES) (
    flow[e] <= a[e]
  );

constraint
  forall(v in N where v != s /\ v != t) (
    sum(e in EDGES where E[e,2] == v)(flow[e]) =
    sum(e in EDGES where E[e,1] == v)(flow[e])
  );

var 0..sum(a): total_flow =
  sum(e in EDGES where E[e,1] == s)(flow[e]) -
  sum(e in EDGES where E[e,2] == s)(flow[e]);

solve maximize total_flow;

output [
  "total_flow=", show(total_flow), "\n",
  "flow=", show(flow), "\n"
];
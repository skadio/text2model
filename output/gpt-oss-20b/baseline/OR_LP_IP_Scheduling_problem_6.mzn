int: n;
int: num_edges;
array[1..num_edges, 1..2] of int: E;
array[1..num_edges] of int: a;
int: s;
int: t;

var 0..sum(a): flow_value;
array[1..num_edges] of var int: flow;

constraint
  forall(i in 1..num_edges) (
    flow[i] >= 0 /\ flow[i] <= a[i]
  );

constraint
  forall(v in 1..n) (
    if v == s then
      sum([flow[i] | i in 1..num_edges where E[i,1] == v]) -
      sum([flow[i] | i in 1..num_edges where E[i,2] == v]) == flow_value
    else if v == t then
      sum([flow[i] | i in 1..num_edges where E[i,2] == v]) -
      sum([flow[i] | i in 1..num_edges where E[i,1] == v]) == flow_value
    else
      sum([flow[i] | i in 1..num_edges where E[i,2] == v]) ==
      sum([flow[i] | i in 1..num_edges where E[i,1] == v])
  );

solve maximize flow_value;

output [
  "Maximum flow: ", show(flow_value), "\n",
  "Flows on edges:\n",
  concat([ show(i), ": ", show(flow[i]), "\n" | i in 1..num_edges ])
];
int: S;
int: G;
int: N;

array[1..S, 1..G] of float: Capacity;
array[1..N, 1..G] of float: Population;
array[1..N, 1..S] of float: Distance;

var float: x[1..N, 1..G, 1..S] >= 0.0;

constraint
  forall(s in 1..S, g in 1..G) (
    sum(n in 1..N) x[n, g, s] <= Capacity[s, g]
  );

constraint
  forall(n in 1..N, g in 1..G) (
    sum(s in 1..S) x[n, g, s] == Population[n, g]
  );

solve minimize
  sum(n in 1..N, g in 1..G, s in 1..S) x[n, g, s] * Distance[n, s];

output [
  "Total distance: ", show(sum(n in 1..N, g in 1..G, s in 1..S) x[n, g, s] * Distance[n, s]), "\n",
  "Assignments:\n",
  concat([ "Neighborhood ", show(n), " Group ", show(g), ":\n",
           concat([ "  School ", show(s), ": ", show(x[n, g, s]), "\n" | s in 1..S]),
           "\n" | n in 1..N, g in 1..G ])
];
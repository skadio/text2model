% Max flow from source (0) to sink (8) over a directed capacitated network

% Parameters
int: n = 9;
set of int: N = 0..n-1;
int: source = 0;
int: sink = 8;

% Capacity matrix (TB/h), 0 => no direct link
array[N, N] of int: cap =
  array2d(N, N,
    [  0, 15,  1,  9, 18, 12, 18,  6, 17,
      14,  0, 13, 11, 14, 10, 15,  4, 15,
       3,  0,  0,  2, 14, 16,  7, 12,  4,
       5, 20,  0,  0,  9,  1, 12,  1, 20,
      11, 18, 12,  3,  0,  4, 16, 15,  2,
      13,  8,  8,  6,  4,  0,  8, 10, 11,
      12,  1,  3,  4, 11,  8,  0, 10, 19,
      18,  3,  9,  5,  9, 17, 10,  0, 13,
       9,  8, 12,  2,  5,  2, 16,  5,  0
    ]);

int: U = max([cap[i,j] | i in N, j in N]);

% Variables
array[N, N] of var 0..U: flow;
var 0..(n * U): totalFlow;

% Constraints

% Capacity adherence / forbid flow on non-existing links
constraint
  forall(i in N, j in N) (
    if cap[i,j] = 0 then
      flow[i,j] = 0
    else
      flow[i,j] <= cap[i,j]
    endif
  );

% Flow conservation at intermediate stations (neither source nor sink)
constraint
  forall(k in N where k != source /\ k != sink) (
    sum(i in N)(flow[i,k]) = sum(j in N)(flow[k,j])
  );

% Define totalFlow as net outflow from the source
constraint
  totalFlow = sum(j in N)(flow[source,j]) - sum(i in N)(flow[i,source]);

% Enforce that the same totalFlow arrives as net inflow at the sink
constraint
  totalFlow = sum(i in N)(flow[i,sink]) - sum(j in N)(flow[sink,j]);

% Objective
solve maximize totalFlow;

% Optional output
output [
  "totalFlow = ", show(totalFlow), "\n"
];
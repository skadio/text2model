% Max flow in a directed capacitated network (FlowCity reservoirs)

% Parameters
int: N = 9;
set of int: V = 0..N-1;

int: source = 0;
int: sink   = 8;

% pipeline capacities (0 = no arc)
array[V, V] of int: cap =
array2d(V, V, [
% to:   0  1  2  3  4  5  6  7  8
       0, 6,16,12,16, 3, 9, 3,13,   % from 0
       2, 0, 0,20,13, 7,20,11,13,   % from 1
       4,15, 0,14,13, 5,12,14,16,   % from 2
       1, 0, 2, 0, 8, 7,11,14,16,   % from 3
       4,19, 7,14, 0, 1,20,14,16,   % from 4
       0, 0,14, 4,17, 0, 2,20, 9,   % from 5
      12,19, 3, 3, 0, 0, 0,13, 3,   % from 6
       8,19,16, 4, 6,13, 9, 0,15,   % from 7
      11, 6, 0, 6,10, 9, 3, 1, 0    % from 8
]);

int: maxCap = max([cap[i,j] | i in V, j in V]);

% Variables
array[V, V] of var 0..maxCap: flow;
var 0..sum(j in V)(cap[source,j]): totalFlow;

% Constraints
constraint forall(i in V, j in V) (
  flow[i,j] <= cap[i,j]
);

% Define total flow as net outflow from source
constraint
  totalFlow = sum(j in V)(flow[source,j]) - sum(i in V)(flow[i,source]);

% Flow conservation at intermediate nodes
constraint forall(v in V where v != source /\ v != sink) (
  sum(i in V)(flow[i,v]) = sum(j in V)(flow[v,j])
);

% Tie to net inflow at sink
constraint
  totalFlow = sum(i in V)(flow[i,sink]) - sum(j in V)(flow[sink,j]);

% Objective
solve maximize totalFlow;

output [
  "Max flow (millions of gallons/day) = ", show(totalFlow), "\n"
];
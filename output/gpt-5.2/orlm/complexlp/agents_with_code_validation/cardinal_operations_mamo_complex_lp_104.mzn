% Max flow from Reservoir 0 to Reservoir 8

int: N = 9;
set of int: RES = 0..N-1;

int: source = 0;
int: sink   = 8;

% Capacity matrix cap[i,j]; 0 means no direct canal
array[RES, RES] of int: cap = array2d(RES, RES, [
%  j=0  1  2  3  4  5  6  7  8
    0,  6,  1, 14, 20,  6, 13, 13, 15,   % i=0
    2,  0,  5,  5, 13,  5, 12,  9, 15,   % i=1
   15,  0,  0,  8, 16,  9, 19, 15,  6,   % i=2
   13,  8,  0,  0, 14, 12,  9,  1,  2,   % i=3
    4, 14, 19, 16,  0, 14, 11, 11,  2,   % i=4
   19, 18,  5, 20,  9,  0, 11,  5,  7,   % i=5
   11, 14, 20, 17, 11, 13,  0, 11, 16,   % i=6
    6,  2, 17,  0, 10, 13, 17,  0,  9,   % i=7
    8,  9,  7, 18, 12, 13,  5,  9,  0    % i=8
]);

int: UB_source = sum(j in RES)(cap[source, j]);
int: UB_sink   = sum(i in RES)(cap[i, sink]);
int: UB_flow   = min(UB_source, UB_sink);

array[RES, RES] of var 0..max(cap): flow;
var 0..UB_flow: maxFlow;

% Capacity constraints (also ensures 0 on non-arcs)
constraint forall(i in RES, j in RES) (
  flow[i,j] <= cap[i,j]
);

% No self-loops
constraint forall(i in RES) (flow[i,i] = 0);

% Flow conservation for intermediate reservoirs
constraint forall(k in RES where k != source /\ k != sink) (
  sum(i in RES)(flow[i,k]) = sum(j in RES)(flow[k,j])
);

% Define maxFlow as net out of source and net into sink
constraint sum(j in RES)(flow[source, j]) - sum(i in RES)(flow[i, source]) = maxFlow;
constraint sum(i in RES)(flow[i, sink])   - sum(j in RES)(flow[sink, j])   = maxFlow;

solve maximize maxFlow;

output [
  "maxFlow = ", show(maxFlow), "\n"
];
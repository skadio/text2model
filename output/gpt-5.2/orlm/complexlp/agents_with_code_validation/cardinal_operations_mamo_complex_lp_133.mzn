% Max flow model (embedded data)

int: n = 9;
set of int: N = 0..n-1;
int: source = 0;
int: sink = 8;

% capacity (Tbps) on directed arc i->j; 0 means no arc
array[N, N] of int: cap = array2d(N, N, [
% to:    0  1  2  3  4  5  6  7  8
         0, 6,20,15, 9,20,17,16,20,   % from 0
         0, 0, 0, 0, 0, 0, 0, 0, 0,   % from 1
         0, 0, 0, 0,19, 0, 0, 0, 0,   % from 2
         0, 0, 0, 0, 0, 0, 0, 0,20,   % from 3
         0, 0, 0, 0, 0, 0, 0, 0, 0,   % from 4
         0, 0, 0, 0, 0, 0, 0, 0, 0,   % from 5
         0, 0, 0, 0, 0, 0, 0, 0, 0,   % from 6
         0, 0, 0,20, 0, 0, 0, 0, 0,   % from 7
         0, 0, 0, 0, 0, 0, 0, 0, 0    % from 8
]);

int: max_cap = max([cap[i,j] | i in N, j in N]);
var 0..sum(j in N)(cap[source,j]): total_flow;

array[N, N] of var 0..max_cap: flow;

% Capacity constraints (also forces flow=0 where cap=0)
constraint forall(i in N, j in N) (flow[i,j] <= cap[i,j]);

% No self-loops
constraint forall(i in N) (flow[i,i] = 0);

% Flow conservation at intermediate nodes
constraint forall(k in N where k != source /\ k != sink) (
  sum(i in N)(flow[i,k]) = sum(j in N)(flow[k,j])
);

% Define total flow as net outflow from source
constraint total_flow =
  sum(j in N)(flow[source,j]) - sum(i in N)(flow[i,source]);

solve maximize total_flow;

output [
  "max_flow=", show(total_flow), "\n"
];
% Parameters
int: n = 7;                               % number of data centers (nodes)
set of int: N = 0..n-1;                   % node index set

int: source = 0;                          % source node (Data Center 0)
int: sink   = 6;                          % sink node   (Data Center 6)

array[N, N] of int: cap =                 % capacity matrix (Tbps); 0 => no link
  [|  0, 18,  2, 10, 17,  0, 12
   | 14,  0,  3,  1, 19, 18,  2
   | 17,  5,  0, 15, 15, 19,  0
   | 14, 17,  0,  0, 19,  9, 16
   |  2, 13, 15, 12,  0, 20,  5
   |  9, 16,  4, 15, 15,  0, 11
   |  8, 10, 19, 19, 17, 16,  0
  |];

% An a-priori upper bound on total flow (sum of capacities leaving source)
int: max_flow_ub = sum(j in N)(cap[source, j]);

% Variables
array[N, N] of var 0..max_flow_ub: flow;  % flow on arc i->j (Tbps)
var 0..max_flow_ub: total_flow;           % total flow from source to sink (Tbps)

% Constraints
%--- Capacity limits: forbid flow where no link exists (cap=0) and cap flow on each arc
constraint forall(i in N, j in N) (
  flow[i, j] <= cap[i, j]
);

%--- Flow conservation at transshipment nodes (all nodes except source and sink)
constraint forall(v in N where v != source /\ v != sink) (
  sum(u in N)(flow[u, v]) = sum(w in N)(flow[v, w])
);

%--- Define total flow as net outflow from the source
constraint
  total_flow = sum(j in N)(flow[source, j]) - sum(j in N)(flow[j, source]);

% Objective
solve maximize total_flow;
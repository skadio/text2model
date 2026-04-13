% Parameters
int: n = 9;                                  % number of distribution centers (nodes)
set of int: N = 0..n-1;                      % node indices

int: source = 0;                             % source node
int: sink   = 8;                             % sink (outskirts) node

% capacity[u,v] = max flow allowed on directed channel u->v (thousand gallons/hour)
array[N, N] of int: capacity =
  [| 0,  9,  7, 18,  0,  0,  7,  0,  2
   |15,  0, 11,  5, 20, 15, 18,  9, 15
   | 3,  8,  0, 10, 16, 18,  8,  0, 20
   |13,  3,  7,  0, 20, 13, 16,  6, 20
   | 7, 20,  2,  4,  0,  9,  3, 14,  2
   |17, 10,  5,  1,  4,  0,  4,  3, 20
   | 0, 20, 10, 10, 15,  5,  0,  1, 10
   |10,  3,  9,  4,  3, 13, 18,  0, 20
   | 2, 12, 10,  5, 15, 14,  0, 10,  0
  |];

% A safe upper bound on total flow value: total outgoing capacity from the source
int: max_total_out_of_source = sum(v in N)(capacity[source, v]);

% Variables
% flow[u,v] = amount of water sent on channel u->v (thousand gallons/hour)
array[N, N] of var 0..max_total_out_of_source: flow;

% total flow value from source to sink
var 0..max_total_out_of_source: total_flow;

% Constraints

%-------------------------------
% Channel capacity constraints
% (also forces flow[u,v]=0 when capacity[u,v]=0 since flow is nonnegative)
%-------------------------------
constraint
  forall(u in N, v in N) (
    flow[u, v] <= capacity[u, v]
  );

%-------------------------------
% Flow conservation constraints
% For every transshipment node, inflow = outflow
%-------------------------------
constraint
  forall(i in N where i != source /\ i != sink) (
    sum(u in N)(flow[u, i]) = sum(v in N)(flow[i, v])
  );

%-------------------------------
% Total flow definition
% Net outflow from the source equals the value of the flow
%-------------------------------
constraint
  total_flow = sum(v in N)(flow[source, v]) - sum(u in N)(flow[u, source]);

% Objective
solve maximize total_flow;
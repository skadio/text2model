% Parameters
int: n = 8;                         % number of data centers (nodes)
set of int: N = 0..n-1;             % node indices
int: source = 0;                    % source node
int: sink = 7;                      % sink node

array[N, N] of int: cap =           % bandwidth capacities (TB/h); 0 means no arc
  [|  0,  6, 16,  5,  6, 11,  6,  4
   |  0,  0,  8, 10,  6,  3,  6, 14
   |  0,  6,  0, 20,  7, 16, 13, 14
   |  0, 11, 19,  0, 18,  5,  0,  8
   |  0,  1, 14, 18,  0, 12,  4,  7
   |  0, 16,  3, 20,  7,  0, 15,  6
   |  0, 11,  4, 19,  7,  6,  0, 17
   |  0,  5,  8, 17,  2,  5,  4,  0 |];

int: maxCap = max([cap[i,j] | i in N, j in N]);  % global upper bound for flow vars

% Variables
array[N, N] of var 0..maxCap: flow;  % flow on arc i->j (TB/h), bounded above by maxCap
var 0..(n * maxCap): totalFlow;       % total flow from source to sink (TB/h), safe upper bound

% Constraints

%--- Capacity enforcement: no arc => zero flow; otherwise bounded by given capacity
constraint
  forall(i in N, j in N) (
    if cap[i,j] = 0 then
      flow[i,j] = 0
    else
      flow[i,j] <= cap[i,j]
    endif
  );

%--- Flow conservation at intermediate nodes (excluding source and sink)
constraint
  forall(k in N where k != source /\ k != sink) (
    sum(i in N)(flow[i,k]) = sum(j in N)(flow[k,j])
  );

%--- Define totalFlow as net outflow from source
constraint
  totalFlow = sum(j in N)(flow[source,j]) - sum(i in N)(flow[i,source]);

%--- Match totalFlow with net inflow to sink (consistency)
constraint
  totalFlow = sum(i in N)(flow[i,sink]) - sum(j in N)(flow[sink,j]);

% Objective
solve maximize totalFlow;
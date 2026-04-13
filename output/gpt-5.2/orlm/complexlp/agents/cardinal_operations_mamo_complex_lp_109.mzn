% Parameters
int: n = 9;                                  % number of stations (nodes)
set of int: N = 0..n-1;                      % node indices
int: source = 0;                             % source station
int: sink = 8;                               % destination station

array[N, N] of int: cap =                    % capacity matrix (packets/hour); 0 = no arc
[|  0, 14, 20,  7,  9,  1,  4,  8, 19
 |  3,  0, 15, 12, 17,  0, 15,  3,  3
 | 11,  8,  0,  1, 19, 16,  5,  1,  2
 | 13, 13,  2,  0, 16, 20, 16, 17,  3
 |  6, 15,  7,  3,  0, 18,  1,  3,  9
 | 15, 20,  8,  4,  6,  0,  3,  1,  4
 |  5, 15, 19,  4, 15, 12,  0,  3,  8
 |  7, 14, 13, 12,  9, 10,  3,  0,  4
 |  3, 12,  6,  6,  1, 11,  6,  1,  0
 |];

int: maxCap = max([cap[i,j] | i in N, j in N]); % upper bound for any single arc flow

% Variables
array[N, N] of var 0..maxCap: flow;            % flow[i,j] sent from station i to station j
var 0..sum(j in N)(cap[source,j]): totalFlow;  % total throughput from source to sink

% Constraints
% Arc capacity enforcement (cap=0 forces flow=0 automatically via flow <= cap)
constraint
  forall(i in N, j in N) (
    flow[i,j] <= cap[i,j]
  );

% Flow conservation at intermediate stations (all nodes except source and sink)
constraint
  forall(k in N where k != source /\ k != sink) (
    sum(i in N)(flow[i,k]) = sum(j in N)(flow[k,j])
  );

% Total throughput definition at the source: net outflow = totalFlow
constraint
  sum(j in N)(flow[source,j]) - sum(i in N)(flow[i,source]) = totalFlow;

% Total throughput consistency at the sink: net inflow = totalFlow
constraint
  sum(i in N)(flow[i,sink]) - sum(j in N)(flow[sink,j]) = totalFlow;

% Objective
solve maximize totalFlow;
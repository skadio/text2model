% Parameters
int: nCities = 6;                      % Number of cities (nodes)
set of int: CITIES = 0..nCities-1;     % City indices

int: source = 0;                       % Source city
int: sink   = 5;                       % Destination city

% Capacity matrix (0 means no direct connection)
array[CITIES, CITIES] of int: cap =
[|  0,  6,  8,  1,  9,  8
 | 16,  0,  6,  0, 12, 16
 |  7, 16,  0, 20, 17,  9
 |  3, 11, 14,  0,  7,  0
 |  6, 19, 19,  3,  0, 20
 | 20,  5, 16, 12,  2,  0 |];

% A simple global upper bound on total flow: sum of outgoing capacities from source
int: maxFlowUB = sum(j in CITIES where j != source)(cap[source, j]);

% Variables
array[CITIES, CITIES] of var 0..maxFlowUB: flow;   % Flow on each directed arc (i->j)
var 0..maxFlowUB: totalFlow;                       % Net flow sent from source

% Constraints

%-----------------------------------------------
% Arc capacity constraints + eliminate self-loops
%-----------------------------------------------
constraint forall(i in CITIES, j in CITIES) (
  if i == j then
    flow[i,j] = 0
  else
    flow[i,j] <= cap[i,j]
  endif
);

%---------------------------------------------------------
% Optional strengthening: no capacity implies no flow (i≠j)
%---------------------------------------------------------
constraint forall(i in CITIES, j in CITIES where i != j /\ cap[i,j] = 0) (
  flow[i,j] = 0
);

%---------------------------------------------------
% Flow conservation on all intermediate (transit) cities
% inflow = outflow for k not source/sink
%---------------------------------------------------
constraint forall(k in CITIES where k != source /\ k != sink) (
  sum(i in CITIES)(flow[i,k]) = sum(j in CITIES)(flow[k,j])
);

%---------------------------------------------------
% Define totalFlow as net outflow from the source
% (equivalently, net inflow to sink in any feasible flow)
%---------------------------------------------------
constraint totalFlow =
  sum(j in CITIES)(flow[source,j]) - sum(i in CITIES)(flow[i,source]);

% Objective
solve maximize totalFlow;
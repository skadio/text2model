% Maximum flow from source (0) to sink (8)

% Parameters
int: nCities = 9;                    % number of cities (0..8)
set of int: CITIES = 0..nCities-1;   % city indices
int: source = 0;                     % Central Hub
int: sink = 8;                       % Key Distribution Center

% capacity[from,to] in thousands of tons (0 means no direct route)
array[CITIES, CITIES] of int: capacity = array2d(CITIES, CITIES, [
% to:   0  1  2  3  4  5  6  7  8
        0, 1,16, 8,18, 4, 0, 8, 5,  % from 0
       15, 0,11, 8,13, 2, 1, 7, 6,  % from 1
       15, 4, 0, 3, 1,13,13,11, 9,  % from 2
        4,16, 8, 0,12,18,19, 8,11,  % from 3
        4,19, 3, 2, 0, 6, 1,13,14,  % from 4
        6,19,15,10,16, 0,17,15,17,  % from 5
       13, 7,13, 4,14, 3, 0, 8, 8,  % from 6
       10, 6,19, 1,12, 6, 9, 0,14,  % from 7
        0, 0, 0, 0, 0, 0, 0, 0, 0   % from 8
]);

int: maxCap = max([capacity[i,j] | i in CITIES, j in CITIES]);

% Variables
array[CITIES, CITIES] of var 0..maxCap: flow;
var 0..sum(j in CITIES)(capacity[source,j]): totalFlow;

% Constraints

% Capacity constraints
constraint forall(i in CITIES, j in CITIES) (
  flow[i,j] <= capacity[i,j]
);

% No self-loops
constraint forall(i in CITIES) (
  flow[i,i] = 0
);

% Flow conservation at intermediate cities
constraint forall(k in CITIES where k != source /\ k != sink) (
  sum(i in CITIES)(flow[i,k]) = sum(j in CITIES)(flow[k,j])
);

% Define totalFlow as net outflow from source
constraint
  totalFlow = sum(j in CITIES)(flow[source,j]) - sum(i in CITIES)(flow[i,source]);

% Net inflow to sink equals totalFlow
constraint
  totalFlow = sum(i in CITIES)(flow[i,sink]) - sum(j in CITIES)(flow[sink,j]);

% Objective
solve maximize totalFlow;

output ["max_flow = ", show(totalFlow), "\n"];
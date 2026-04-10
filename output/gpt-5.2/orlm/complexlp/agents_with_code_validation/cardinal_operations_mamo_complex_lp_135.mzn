% Maximum flow in a directed network (capacities in thousands of vehicles/hour)

int: nCities = 8;
set of int: CITIES = 0..nCities-1;

int: source = 0;
int: sink   = 7;

% Capacity matrix (0 means no direct arc)
array[CITIES, CITIES] of int: cap =
array2d(CITIES, CITIES, [
% to:   0   1   2   3   4   5   6   7
        0, 18,  5,  6,  8, 10, 16,  0,  % from 0
       18,  0,  1, 15, 20, 13,  1,  2,  % from 1
       18, 16,  0, 19, 15,  4,  9, 10,  % from 2
       20,  2, 18,  0, 19, 17, 15, 19,  % from 3
       14, 13, 14,  1,  0,  8, 16, 20,  % from 4
        0, 17, 18, 10, 17,  0, 16,  6,  % from 5
        5, 14, 19,  6,  0, 19,  0, 12,  % from 6
        7, 16, 17, 13,  6,  9,  5,  0   % from 7
]);

% Upper bound on total flow: sum of capacities leaving source
int: maxTotalFlow = sum(j in CITIES)(cap[source, j]);

% Decision variables: flow on each directed arc
array[CITIES, CITIES] of var 0..maxTotalFlow: flow;

% Objective value: net flow from source to sink
var 0..maxTotalFlow: totalFlow;

% Capacity constraints (also forces 0 when cap is 0)
constraint forall(i in CITIES, j in CITIES) (
  flow[i,j] <= cap[i,j]
);

% No self-loops
constraint forall(i in CITIES) (
  flow[i,i] = 0
);

% Flow conservation at intermediate nodes
constraint forall(v in CITIES where v != source /\ v != sink) (
  sum(i in CITIES)(flow[i,v]) = sum(j in CITIES)(flow[v,j])
);

% Define totalFlow as net outflow from source
constraint
  totalFlow = sum(j in CITIES)(flow[source,j]) - sum(i in CITIES)(flow[i,source]);

% Also equal to net inflow to sink (redundant but consistent)
constraint
  totalFlow = sum(i in CITIES)(flow[i,sink]) - sum(j in CITIES)(flow[sink,j]);

solve maximize totalFlow;

output ["max_flow_thousands_per_hour=" ++ show(totalFlow) ++ "\n"];
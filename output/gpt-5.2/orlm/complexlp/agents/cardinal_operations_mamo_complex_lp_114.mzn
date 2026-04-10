% Parameters
int: nCities = 6;                               % Number of cities (nodes)
set of int: CITIES = 0..nCities-1;              % City indices

int: source = 0;                                % Source city
int: sink   = 5;                                % Destination city

array[CITIES, CITIES] of int: cap =             % Highway capacities (thousands of vehicles/hour)
[
|  0,  9, 13,  0, 20, 16
|  6,  0, 19, 11, 14, 15
| 11,  6,  0,  8,  3, 10
| 16,  2, 17,  0,  1, 17
|  4, 12,  5, 16,  0, 15
|  7, 19, 18,  6,  8,  0
];

int: maxCap = max([cap[i,j] | i in CITIES, j in CITIES]); % Upper bound for arc flows

% Variables
array[CITIES, CITIES] of var 0..maxCap: flow;   % Flow on each directed highway (thousands/hour)
var 0..(nCities*maxCap): maxFlow;               % Total flow from source to sink (thousands/hour)

% Constraints
% Capacity / existence constraints: respect capacities (cap=0 forces flow=0)
constraint
  forall(i in CITIES, j in CITIES) (
    flow[i,j] <= cap[i,j]
  );

% No self-loop flow (clarity; also implied by cap[i,i]=0)
constraint
  forall(i in CITIES) (
    flow[i,i] = 0
  );

% Flow conservation at intermediate cities (all except source and sink)
constraint
  forall(k in CITIES where k != source /\ k != sink) (
    sum(j in CITIES)(flow[j,k]) = sum(j in CITIES)(flow[k,j])
  );

% Define maxFlow as net outflow from source
constraint
  maxFlow = sum(j in CITIES)(flow[source,j]) - sum(j in CITIES)(flow[j,source]);

% Ensure the same maxFlow equals net inflow to sink (consistency)
constraint
  maxFlow = sum(j in CITIES)(flow[j,sink]) - sum(j in CITIES)(flow[sink,j]);

% Objective
solve maximize maxFlow;
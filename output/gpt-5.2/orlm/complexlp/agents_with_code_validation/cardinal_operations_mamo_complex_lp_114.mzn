% Parameters
int: nCities = 6;                             % number of cities (nodes)
set of int: CITIES = 0..nCities-1;            % city indices

int: source = 0;                              % source city
int: sink   = 5;                              % destination city

% Capacity matrix (in thousands of vehicles per hour).
% cap[i,j] = 0 means no direct highway from i to j.
array[CITIES, CITIES] of int: cap =
  array2d(CITIES, CITIES,
    [ 0,  9, 13,  0, 20, 16,
      6,  0, 19, 11, 14, 15,
     11,  6,  0,  8,  3, 10,
     16,  2, 17,  0,  1, 17,
      4, 12,  5, 16,  0, 15,
      7, 19, 18,  6,  8,  0
    ]);

% Upper bound for total flow value (safe bound: sum of capacities out of source)
int: maxTotalOutOfSource = sum(j in CITIES)(cap[source, j]);

% Variables
array[CITIES, CITIES] of var 0..maxTotalOutOfSource: flow;  % flow on each directed highway (thousands/hour)
var 0..maxTotalOutOfSource: totalFlow;                      % total flow sent from source to sink (thousands/hour)

% Constraints

% --- Capacity / existence of arcs ---
% Flow on any directed highway cannot exceed its capacity; if cap=0 then flow=0 automatically.
constraint
  forall(i in CITIES, j in CITIES) (
    flow[i,j] <= cap[i,j]
  );

% --- Flow conservation at intermediate cities ---
% For every city other than source and sink: total inflow equals total outflow.
constraint
  forall(k in CITIES where k != source /\ k != sink) (
    sum(i in CITIES)(flow[i,k]) = sum(j in CITIES)(flow[k,j])
  );

% --- Define total flow value ---
% Total flow equals net outflow from source and also equals net inflow to sink.
constraint
  totalFlow = sum(j in CITIES)(flow[source,j]) - sum(i in CITIES)(flow[i,source]);

constraint
  totalFlow = sum(i in CITIES)(flow[i,sink]) - sum(j in CITIES)(flow[sink,j]);

% Objective
solve maximize totalFlow;
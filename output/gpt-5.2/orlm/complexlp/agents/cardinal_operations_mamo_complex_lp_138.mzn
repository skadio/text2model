% Parameters
int: nCities = 6;                             % number of cities (0..5)
set of int: CITIES = 0..nCities-1;            % city indices
int: source = 0;                              % City 0 (Warehouse)
int: sink   = 5;                              % City 5 (Retail Hub)

array[CITIES, CITIES] of int: cap =           % capacity matrix (0 => no direct highway)
[
  % to:  0   1   2   3   4   5
  /*0*/ [0, 14, 15, 13,  0,  4],
  /*1*/ [10, 0,  7, 18,  9,  5],
  /*2*/ [11, 0,  0,  7, 13,  6],
  /*3*/ [ 7, 11, 18,  0, 17,  2],
  /*4*/ [19,  8, 15, 15,  0,  5],
  /*5*/ [10, 19, 17,  2,  3,  0]
];

int: maxCap = max([cap[i,j] | i in CITIES, j in CITIES]); % upper bound helper


% Variables
array[CITIES, CITIES] of var 0..maxCap: flow;  % flow (trucks/hour) on each directed highway
var 0..sum(j in CITIES)(cap[source, j]): totalFlow; % net dispatched flow from source


% Constraints
% --- Capacity compliance on every directed highway (0 capacity => forced 0 flow) ---
constraint
  forall(i in CITIES, j in CITIES) (
    flow[i,j] <= cap[i,j]
  );

% --- Flow conservation at all intermediate cities (neither source nor sink) ---
constraint
  forall(k in CITIES where k != source /\ k != sink) (
    sum(i in CITIES)(flow[i,k]) = sum(j in CITIES)(flow[k,j])
  );

% --- Define total dispatched flow as net outflow from the source ---
constraint
  totalFlow =
    sum(j in CITIES)(flow[source, j]) - sum(i in CITIES)(flow[i, source]);

% --- Optional strengthening: totalFlow equals net inflow to the sink (redundant but tightens) ---
constraint
  totalFlow =
    sum(i in CITIES)(flow[i, sink]) - sum(j in CITIES)(flow[sink, j]);


% Objective
solve maximize totalFlow;
% Parameters
int: nCities = 6;                          % Number of cities (nodes)
set of int: Cities = 0..nCities-1;         % City indices
int: source = 0;                           % Source city
int: sink = 5;                             % Destination city

array[Cities, Cities] of int: cap =        % Track capacities cap[i,j]
[
  % to:    0   1   2   3   4   5
  /*0*/ [  0, 17, 14, 13, 11,  3],
  /*1*/ [  1,  0, 18, 14, 12, 16],
  /*2*/ [  5,  1,  0,  7,  2,  5],
  /*3*/ [ 10, 13, 19,  0,  4, 16],
  /*4*/ [  3,  0, 13,  0,  0, 14],
  /*5*/ [ 15, 16,  4,  1, 16,  0]
];

int: maxCap = max([cap[i,j] | i in Cities, j in Cities]); % Upper bound for any single arc flow

% Variables
array[Cities, Cities] of var 0..maxCap: flow;  % Trains sent on each directed track i->j
var 0..(nCities * maxCap): totalFlow;          % Total trains dispatched from source to sink (bounded)

% Constraints
% --- Capacity / existence constraints: enforce 0 flow on non-existent tracks and upper-bound by capacity ---
constraint
  forall(i in Cities, j in Cities) (
    flow[i,j] <= cap[i,j]
  );

% --- No self-loops: no trains can be sent from a city to itself ---
constraint
  forall(i in Cities) (
    flow[i,i] = 0
  );

% --- Flow conservation at intermediate cities (neither source nor sink) ---
constraint
  forall(v in Cities where v != source /\ v != sink) (
    sum(j in Cities)(flow[v,j]) = sum(i in Cities)(flow[i,v])
  );

% --- Define totalFlow as net outflow from the source ---
constraint
  totalFlow =
    sum(j in Cities)(flow[source,j]) - sum(i in Cities)(flow[i,source]);

% --- Consistency: same totalFlow equals net inflow to the sink ---
constraint
  totalFlow =
    sum(i in Cities)(flow[i,sink]) - sum(j in Cities)(flow[sink,j]);

% Objective
solve maximize totalFlow;
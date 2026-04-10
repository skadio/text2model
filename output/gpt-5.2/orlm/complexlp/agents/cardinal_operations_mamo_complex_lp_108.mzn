% Parameters
int: nStations = 8;                          % Number of stations (0..7)
set of int: ST = 0..nStations-1;             % Station index set

int: source = 0;                             % Source station
int: sink   = 7;                             % Destination station

array[ST, ST] of int: cap =                  % Capacity matrix (MW); 0 means no arc
[|  0,  9,  6,  1,  8, 14,  1, 17
 |  1,  0,  6, 14, 16,  8, 19, 15
 |  4,  7,  0,  9,  1,  2,  9,  4
 | 11,  5, 14,  0, 17,  6, 20, 13
 |  8,  5, 20,  0,  0, 16,  5,  5
 | 15, 18,  9,  1, 19,  0, 16,  0
 | 20, 15,  1,  0, 11,  6,  0, 19
 |  4, 18, 10,  2,  1, 20, 14,  0
|];

int: totalCapOutSource = sum(j in ST)(cap[source, j]);   % Upper bound for max flow


% Variables
array[ST, ST] of var 0..totalCapOutSource: flow;         % Flow on each directed arc (MW)
var 0..totalCapOutSource: maxFlow;                       % Total flow from source to sink (MW)


% Constraints

% --- Capacity / arc existence constraints ---
% Respect arc capacities; if cap[i,j]=0 then flow[i,j]=0 is enforced.
constraint
  forall(i in ST, j in ST) (
    flow[i,j] <= cap[i,j]
  );

% --- No self-loop flow ---
constraint
  forall(i in ST) (
    flow[i,i] = 0
  );

% --- Flow conservation constraints ---
% For intermediate stations, inflow = outflow.
constraint
  forall(k in ST where k != source /\ k != sink) (
    sum(i in ST)(flow[i,k]) = sum(j in ST)(flow[k,j])
  );

% --- Define maxFlow consistently with source and sink balance ---
% Total flow leaving source minus entering source equals maxFlow.
constraint
  maxFlow = sum(j in ST)(flow[source,j]) - sum(i in ST)(flow[i,source]);

% Total flow entering sink minus leaving sink equals maxFlow.
constraint
  maxFlow = sum(i in ST)(flow[i,sink]) - sum(j in ST)(flow[sink,j]);


% Objective
solve maximize maxFlow;
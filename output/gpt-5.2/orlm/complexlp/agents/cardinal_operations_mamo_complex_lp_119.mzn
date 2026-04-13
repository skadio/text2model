% Parameters
int: nStations = 6;                         % number of stations (0..5)
set of int: ST = 0..nStations-1;            % station index set
int: source = 0;                            % source station (Power Plant)
int: sink = 5;                              % sink station (Main Distribution Hub)

array[ST, ST] of int: cap =                 % capacity matrix (MW); 0 means no arc
  [| 0,  4, 12, 19, 13, 11
   |20,  0, 13,  9, 10,  0
   |14,  8,  0,  5, 13, 11
   | 5, 15, 18,  0,  6,  7
   | 8, 17, 20, 14,  0,  9
   | 9, 19, 19, 11,  4,  0 |];

int: maxCap = max([cap[i,j] | i in ST, j in ST]);  % used for variable bounds

% Variables
array[ST, ST] of var 0..maxCap: flow;       % flow on each directed arc (MW)
var 0..(nStations*maxCap): totalFlow;        % total flow sent from source to sink (MW)

% Constraints

% --- Capacity / arc existence constraints ---
% No flow is allowed on non-existent arcs (where capacity is 0),
% and flow must not exceed capacity on existing arcs.
constraint
  forall(i in ST, j in ST) (
    flow[i,j] <= cap[i,j]
  );

% --- Flow conservation constraints ---
% For intermediate stations (neither source nor sink), enforce conservation:
% total inflow equals total outflow.
constraint
  forall(k in ST where k != source /\ k != sink) (
    sum(i in ST)(flow[i,k]) = sum(j in ST)(flow[k,j])
  );

% --- Total flow definition constraints ---
% Define totalFlow as net outflow from the source (out - in).
constraint
  totalFlow = sum(j in ST)(flow[source,j]) - sum(i in ST)(flow[i,source]);

% Define totalFlow as net inflow to the sink (in - out) to ensure consistency.
constraint
  totalFlow = sum(i in ST)(flow[i,sink]) - sum(j in ST)(flow[sink,j]);

% Objective
solve maximize totalFlow;
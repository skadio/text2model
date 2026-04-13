% Parameters
int: nStations = 9;                              % Number of relay stations (0..8)
set of int: ST = 0..nStations-1;                 % Station indices
int: source = 0;                                 % Source station
int: sink   = 8;                                 % Destination station

% Capacity matrix (TB/hour). 0 means no direct link.
array[ST, ST] of int: cap =
array2d(ST, ST, [
  % to:  0,  1,  2,  3,  4,  5,  6,  7,  8
        0, 15,  1,  9, 18, 12, 18,  6, 17,   % from 0
       14,  0, 13, 11, 14, 10, 15,  4, 15,   % from 1
        3,  0,  0,  2, 14, 16,  7, 12,  4,   % from 2
        5, 20,  0,  0,  9,  1, 12,  1, 20,   % from 3
       11, 18, 12,  3,  0,  4, 16, 15,  2,   % from 4
       13,  8,  8,  6,  4,  0,  8, 10, 11,   % from 5
       12,  1,  3,  4, 11,  8,  0, 10, 19,   % from 6
       18,  3,  9,  5,  9, 17, 10,  0, 13,   % from 7
        9,  8, 12,  2,  5,  2, 16,  5,  0    % from 8
]);

int: maxCap = max([cap[i,j] | i in ST, j in ST]); % Upper bound helper for flows

% Variables
array[ST, ST] of var 0..maxCap: flow;           % flow[i,j] is TB/hour sent from i to j
var 0..sum(j in ST)(cap[source,j]): totalFlow;  % Total TB/hour transmitted from source to sink


% Constraints

% --- Capacity / existence constraints ---
% Respect arc capacities; if there is no direct link (cap = 0) then enforce zero flow.
constraint
  forall(i in ST, j in ST) (
    flow[i,j] <= cap[i,j]
  );

% --- No self-loop flow ---
% Disallow sending flow from a station to itself.
constraint
  forall(i in ST) (
    flow[i,i] = 0
  );

% --- Flow conservation constraints ---
% For intermediate stations, inflow equals outflow.
constraint
  forall(k in ST where k != source /\ k != sink) (
    sum(i in ST)(flow[i,k]) = sum(j in ST)(flow[k,j])
  );

% --- Define totalFlow consistently with source and sink balance ---
% Net outflow from source equals totalFlow.
constraint
  totalFlow = sum(j in ST)(flow[source,j]) - sum(i in ST)(flow[i,source]);

% Net inflow to sink equals totalFlow.
constraint
  totalFlow = sum(i in ST)(flow[i,sink]) - sum(j in ST)(flow[sink,j]);


% Objective
solve maximize totalFlow;
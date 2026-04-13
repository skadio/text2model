% Parameters
int: nStations = 9;                         % Number of pumping stations (0..8)
set of int: STATIONS = 0..nStations-1;      % Station indices
int: source = 0;                            % Source station
int: sink = 8;                              % Destination station

% Pipeline capacities (thousand gallons/hour)
array[STATIONS, STATIONS] of int: cap =
array2d(STATIONS, STATIONS, [
  % from 0
   0,  5,  2,  7, 17,  4,  1,  2, 13,
  % from 1
  12,  0, 15, 18,  8,  9,  8,  1, 15,
  % from 2
  17, 16,  0, 20, 17, 13,  2, 19,  6,
  % from 3
   5,  9, 14,  0, 10, 18, 20,  9, 18,
  % from 4
  12, 14,  7,  6,  0,  6, 17,  4,  9,
  % from 5
  12, 11, 10,  1, 13,  0, 14, 12, 14,
  % from 6
  13,  7,  3,  9,  1, 14,  0,  7, 16,
  % from 7
  18, 15,  8,  0, 12, 13,  5,  0, 17,
  % from 8
   3, 11, 15, 14,  0,  4, 18, 16,  0
]);

int: maxPossibleFlow = sum(j in STATIONS)(cap[source, j]); % Upper bound on total flow

% Variables
array[STATIONS, STATIONS] of var 0..maxPossibleFlow: flow; % Flow on each directed pipeline
var 0..maxPossibleFlow: totalFlow;                          % Total flow from source to sink

% Constraints

% Capacity constraints (also forces zero flow where capacity is 0)
constraint
  forall(i in STATIONS, j in STATIONS) (
    flow[i, j] <= cap[i, j]
  );

% Flow conservation at intermediate stations
constraint
  forall(k in STATIONS where k != source /\ k != sink) (
    sum(i in STATIONS)(flow[i, k]) = sum(j in STATIONS)(flow[k, j])
  );

% Define totalFlow as net outflow from source
constraint
  totalFlow =
    sum(j in STATIONS)(flow[source, j]) - sum(i in STATIONS)(flow[i, source]);

% Ensure same net flow arrives at sink
constraint
  totalFlow =
    sum(i in STATIONS)(flow[i, sink]) - sum(j in STATIONS)(flow[sink, j]);

% Objective
solve maximize totalFlow;
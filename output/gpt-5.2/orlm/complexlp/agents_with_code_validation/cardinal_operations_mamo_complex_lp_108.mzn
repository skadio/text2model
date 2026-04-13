% Maximum flow from source (0) to sink (7) on a directed network

int: nStations = 8;
set of int: Stations = 0..nStations-1;
int: source = 0;
int: sink = 7;

% Capacity matrix (MW); 0 means no arc.
% Use array2d to coerce indices to 0..7 as required.
array[Stations, Stations] of int: cap =
  array2d(Stations, Stations,
  [
     0,  9,  6,  1,  8, 14,  1, 17,
     1,  0,  6, 14, 16,  8, 19, 15,
     4,  7,  0,  9,  1,  2,  9,  4,
    11,  5, 14,  0, 17,  6, 20, 13,
     8,  5, 20,  0,  0, 16,  5,  5,
    15, 18,  9,  1, 19,  0, 16,  0,
    20, 15,  1,  0, 11,  6,  0, 19,
     4, 18, 10,  2,  1, 20, 14,  0
  ]);

int: maxCap = max([cap[i,j] | i in Stations, j in Stations]);

array[Stations, Stations] of var 0..maxCap: flow;
var 0..(nStations * maxCap): totalFlow;

% Capacity constraints (also force flow=0 when cap=0)
constraint forall(i in Stations, j in Stations) (
  flow[i,j] <= cap[i,j]
);

% No self-loops
constraint forall(i in Stations) (flow[i,i] = 0);

% Flow conservation at intermediate nodes
constraint forall(k in Stations where k != source /\ k != sink) (
  sum(i in Stations)(flow[i,k]) = sum(j in Stations)(flow[k,j])
);

% Define objective value as net outflow from source
constraint totalFlow =
  sum(j in Stations)(flow[source,j]) - sum(i in Stations)(flow[i,source]);

% Consistency: net inflow to sink equals totalFlow
constraint totalFlow =
  sum(i in Stations)(flow[i,sink]) - sum(j in Stations)(flow[sink,j]);

solve maximize totalFlow;

output [
  "Maximum flow = ", show(totalFlow), " MW\n"
];
% Max-flow in a directed network (Aquaville water distribution)

include "globals.mzn";

int: nStations = 9;
set of int: Stations = 0..nStations-1;
int: Source = 0;
int: Sink = 8;

% Capacity matrix (0 means no direct arc)
array[Stations, Stations] of int: cap =
[
|  0,  2,  8, 17, 16, 20, 15, 12,  9 |
|  4,  0, 11,  7,  3, 19, 10, 19,  8 |
| 14,  7,  0,  7, 13, 19, 18, 20,  5 |
| 17, 17,  7,  0, 11,  7, 17,  0, 10 |
| 20, 10,  2, 18,  0, 15,  8,  6, 18 |
|  4,  9, 12,  1, 17,  0,  0, 13, 18 |
| 12, 15, 12, 19, 18, 19,  0,  6, 17 |
| 14,  1, 17, 20, 11, 20,  6,  0,  4 |
| 19,  3, 19, 12,  8, 18, 17, 13,  0 |
];

% Use a safe, explicit upper bound (avoid comprehension-based max that can
% trigger toolchain issues in some environments)
int: maxArcCap = 20;
int: maxOutOfSource = 2+8+17+16+20+15+12+9; % = 99

% Decision variables: flow on each directed arc
array[Stations, Stations] of var 0..maxArcCap: flow;

var 0..maxOutOfSource: totalFlow;

% Capacity constraints (also forces flow=0 when cap=0)
constraint forall(i in Stations, j in Stations) (
  flow[i,j] <= cap[i,j]
);

% No self-loop flow
constraint forall(i in Stations) ( flow[i,i] = 0 );

% Flow conservation at intermediate nodes
constraint forall(k in Stations where k != Source /\ k != Sink) (
  sum(i in Stations)(flow[i,k]) = sum(j in Stations)(flow[k,j])
);

% Define totalFlow as net outflow from Source
constraint totalFlow =
  sum(j in Stations)(flow[Source,j]) - sum(i in Stations)(flow[i,Source]);

% Ensure same value equals net inflow to Sink
constraint totalFlow =
  sum(i in Stations)(flow[i,Sink]) - sum(j in Stations)(flow[Sink,j]);

solve maximize totalFlow;

output [
  "Maximum flow (thousand gallons/hour) = ", show(totalFlow), "\n"
];
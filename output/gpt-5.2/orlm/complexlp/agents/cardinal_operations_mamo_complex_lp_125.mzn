% Parameters
int: nStations = 9;                           % Number of pumping stations (0..8)
set of int: STATIONS = 0..nStations-1;        % Station index set

int: source = 0;                              % Source station
int: sink   = 8;                              % Destination station

array[STATIONS, STATIONS] of int: cap =       % Pipeline capacities (thousand gallons/hour)
[
 % to:   0  1  2  3  4  5  6  7  8
        [0, 5, 2, 7,17, 4, 1, 2,13],  % from 0
        [12,0,15,18, 8, 9, 8, 1,15],  % from 1
        [17,16,0,20,17,13, 2,19, 6],  % from 2
        [5, 9,14,0,10,18,20, 9,18],   % from 3
        [12,14,7, 6,0, 6,17, 4, 9],   % from 4
        [12,11,10,1,13,0,14,12,14],   % from 5
        [13,7, 3, 9, 1,14,0, 7,16],   % from 6
        [18,15,8, 0,12,13, 5,0,17],   % from 7
        [3,11,15,14,0, 4,18,16,0]     % from 8
];

int: maxCap = max([cap[i,j] | i in STATIONS, j in STATIONS]); % Used for flow var upper bound


% Variables
array[STATIONS, STATIONS] of var 0..maxCap: flow;  % Flow on each directed pipeline (thousand gal/hour)

% Total flow from source to sink: bounded by total outgoing capacity of the source
var 0..(sum(j in STATIONS)(cap[source,j])): totalFlow;


% Constraints
%------------------------------------------------------------------------------
% No self-loop flow (diagonal arcs)
%------------------------------------------------------------------------------
constraint
  forall(i in STATIONS) (
    flow[i,i] = 0
  );

%------------------------------------------------------------------------------
% Capacity constraints and enforce 0 flow where no pipeline exists
% (Given flow domains are nonnegative, so cap=0 forces flow=0)
%------------------------------------------------------------------------------
constraint
  forall(i in STATIONS, j in STATIONS) (
    flow[i,j] <= cap[i,j]
  );

%------------------------------------------------------------------------------
% Flow conservation at intermediate stations (all except source and sink)
%------------------------------------------------------------------------------
constraint
  forall(k in STATIONS where k != source /\ k != sink) (
    sum(i in STATIONS)(flow[i,k]) = sum(j in STATIONS)(flow[k,j])
  );

%------------------------------------------------------------------------------
% Define total flow as net outflow from the source
%------------------------------------------------------------------------------
constraint
  totalFlow = sum(j in STATIONS)(flow[source,j]) - sum(i in STATIONS)(flow[i,source]);


% Objective
solve maximize totalFlow;

output [
  "Maximum flow (thousand gallons/hour) = ", show(totalFlow), "\n"
];
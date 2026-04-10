% Parameters
int: nStations = 9;                         % Number of stations (0..8)
set of int: ST = 0..nStations-1;            % Station indices

int: source = 0;                            % Source station
int: sink   = 8;                            % Destination station

array[ST, ST] of int: cap =                 % Capacity matrix (0 => no direct arc)
[|  0,  2,  8, 17, 16, 20, 15, 12,  9
 |  4,  0, 11,  7,  3, 19, 10, 19,  8
 | 14,  7,  0,  7, 13, 19, 18, 20,  5
 | 17, 17,  7,  0, 11,  7, 17,  0, 10
 | 20, 10,  2, 18,  0, 15,  8,  6, 18
 |  4,  9, 12,  1, 17,  0,  0, 13, 18
 | 12, 15, 12, 19, 18, 19,  0,  6, 17
 | 14,  1, 17, 20, 11, 20,  6,  0,  4
 | 19,  3, 19, 12,  8, 18, 17, 13,  0 |];

int: maxCap = max([cap[i,j] | i in ST, j in ST]); % Upper bound helper for flow vars

% Variables
array[ST, ST] of var 0..maxCap: flow;       % Flow on each directed arc (thousands of gallons/hour)
var 0..(maxCap * (nStations-1)): totalFlow;  % Total flow from source to sink (objective variable)

% Constraints

%--------------------------------------------------------------------
% Capacity compliance: no arc can carry more than its given capacity
% (and arcs with cap=0 are forced to carry 0 flow via the same bound)
%--------------------------------------------------------------------
constraint
  forall(i in ST, j in ST) (
    flow[i,j] <= cap[i,j]
  );

%--------------------------------------------------------------------
% Flow conservation at intermediate stations:
% For every station except source and sink, inflow equals outflow.
%--------------------------------------------------------------------
constraint
  forall(k in ST where k != source /\ k != sink) (
    sum(i in ST)(flow[i,k]) = sum(j in ST)(flow[k,j])
  );

%--------------------------------------------------------------------
% Define totalFlow as net outflow from the source (out - in)
%--------------------------------------------------------------------
constraint
  totalFlow = sum(j in ST)(flow[source,j]) - sum(i in ST)(flow[i,source]);

%--------------------------------------------------------------------
% Define totalFlow consistently as net inflow to the sink (in - out)
%--------------------------------------------------------------------
constraint
  totalFlow = sum(i in ST)(flow[i,sink]) - sum(j in ST)(flow[sink,j]);

% Objective
solve maximize totalFlow;
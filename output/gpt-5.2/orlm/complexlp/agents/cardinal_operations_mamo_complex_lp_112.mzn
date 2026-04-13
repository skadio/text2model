% Parameters
int: nCities = 9;                          % Number of cities (nodes)
set of int: CITIES = 0..nCities-1;         % City indices
int: source = 0;                           % Source city
int: sink = 8;                             % Destination city

array[CITIES, CITIES] of int: cap =        % Capacity on directed arc (i->j); 0 means no arc
[
%    0  1  2  3  4  5  6  7  8   (to)
    [0, 0,20,10, 0, 2,11, 5,12],  % from 0
    [7, 0, 5, 9, 9,16, 1,17, 7],  % from 1
    [3,17, 0, 1, 5,18,13,12,14],  % from 2
    [9,10, 2, 0,10,11,11, 5,10],  % from 3
    [7, 5, 1,19, 0,19,12,14,15],  % from 4
    [16,4, 6,15,19, 0, 0, 0,20],  % from 5 (no arc to 6/7)
    [3, 0,17,16,19, 8, 0, 8, 9],  % from 6 (no arc to 1)
    [14,11,13,17,10,13,20, 0,16], % from 7
    [20,5,20,16, 0,15, 1,12, 0]   % from 8 (no arc to 4, and no self-loop)
];

% Variables
array[CITIES, CITIES] of var 0..max(cap): flow;  % Flow on directed arc (i->j)
var 0..sum(j in CITIES)(cap[source,j]): totalFlow; % Total flow value (bounded by outgoing capacity of source)

% Constraints
%------------------------------------------------------------
% Capacity bounds on each arc (kept explicit for clarity)
%------------------------------------------------------------
constraint forall(i in CITIES, j in CITIES) (
  flow[i,j] >= 0 /\ flow[i,j] <= cap[i,j]
);

%------------------------------------------------------------
% Enforce "no arc => no flow" (capacity 0 implies fixed 0 flow)
%------------------------------------------------------------
constraint
  forall(i in CITIES, j in CITIES where cap[i,j] = 0) (
    flow[i,j] = 0
  );

%------------------------------------------------------------
% Disallow self-loops (no flow from a city to itself)
%------------------------------------------------------------
constraint
  forall(i in CITIES) (
    flow[i,i] = 0
  );

%------------------------------------------------------------
% totalFlow definition (net outflow of source)
%------------------------------------------------------------
constraint
  totalFlow = sum(j in CITIES)(flow[source,j]) - sum(i in CITIES)(flow[i,source]);

%------------------------------------------------------------
% Flow conservation for intermediate nodes (excluding source and sink)
%------------------------------------------------------------
constraint
  forall(k in CITIES where k != source /\ k != sink) (
    sum(i in CITIES)(flow[i,k]) = sum(j in CITIES)(flow[k,j])
  );

%------------------------------------------------------------
% Net inflow to sink equals totalFlow
%------------------------------------------------------------
constraint
  totalFlow = sum(i in CITIES)(flow[i,sink]) - sum(j in CITIES)(flow[sink,j]);

% Objective
solve maximize totalFlow;
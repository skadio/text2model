% Parameters
int: nStations = 7;                          % number of stations (0..6)
set of int: ST = 0..nStations-1;             % station indices
int: source = 0;                             % source station
int: sink   = 6;                             % sink station

array[ST, ST] of int: cap =                  % capacity matrix (TB/hour); 0 => no link
  array2d(ST, ST,
  [ 0, 17,  3, 20, 11, 11,  3,
   11,  0, 12, 18,  5,  6,  4,
    7,  2,  0, 15, 13, 20, 18,
    7,  4,  2,  0,  2, 15,  3,
   19, 12, 16,  4,  0, 19,  4,
   13, 20, 10, 14, 15,  0,  1,
    3,  3,  6, 20,  9, 10,  0 ]);

int: maxCap = max([cap[i,j] | i in ST, j in ST]); % upper bound helper for flows

% Variables
array[ST, ST] of var 0..maxCap: flow;        % flow on directed arc i->j (TB/hour)
var 0..(nStations * maxCap): totalFlow;       % total flow sent from source to sink (TB/hour)

% Constraints

% --- Capacity / existence of arcs ---
% If there is no link (cap = 0), enforce zero flow; otherwise flow is bounded by cap below.
constraint
  forall(i in ST, j in ST where i != j) (
    (cap[i,j] = 0) -> (flow[i,j] = 0)
  );

% No self-loop flow
constraint
  forall(i in ST) (
    flow[i,i] = 0
  );

% Enforce capacity upper bounds on existing arcs
constraint
  forall(i in ST, j in ST where i != j) (
    flow[i,j] <= cap[i,j]
  );

% --- Flow conservation (Kirchhoff) on intermediate stations ---
% For all stations except source and sink: inflow equals outflow.
constraint
  forall(k in ST where k != source /\ k != sink) (
    sum(i in ST)(flow[i,k]) = sum(j in ST)(flow[k,j])
  );

% --- Define totalFlow consistently with source outflow and sink inflow ---
constraint
  totalFlow = sum(j in ST)(flow[source,j]);

constraint
  totalFlow = sum(i in ST)(flow[i,sink]);

% Objective
solve maximize totalFlow;
% Parameters
int: N = 9;                               % number of reservoirs (0..8)
set of int: RES = 0..N-1;                 % reservoir indices
int: SOURCE = 0;                          % source reservoir
int: SINK = 8;                            % sink reservoir

array[RES, RES] of int: cap =             % capacity matrix (million gallons/day); 0 = no arc
[
  % to:  0  1  2  3  4  5  6  7  8
  /*0*/ [0, 6, 1,14,20, 6,13,13,15],
  /*1*/ [2, 0, 5, 5,13, 5,12, 9,15],
  /*2*/ [15,0, 0, 8,16, 9,19,15, 6],
  /*3*/ [13,8, 0, 0,14,12, 9, 1, 2],
  /*4*/ [4,14,19,16, 0,14,11,11, 2],
  /*5*/ [19,18,5,20, 9, 0,11, 5, 7],
  /*6*/ [11,14,20,17,11,13, 0,11,16],
  /*7*/ [6, 2,17, 0,10,13,17, 0, 9],
  /*8*/ [8, 9, 7,18,12,13, 5, 9, 0]
];

int: MAXCAP = max([cap[i,j] | i in RES, j in RES]);  % upper bound on any single arc capacity


% Variables
array[RES, RES] of var 0..MAXCAP: flow;  % flow on each directed arc (million gallons/day)
var 0..(sum(j in RES) (cap[SOURCE,j])): total_flow;  % total flow from SOURCE to SINK


% Constraints

% Capacity enforcement: no flow can exceed arc capacity (and 0-capacity arcs carry 0 flow)
constraint
  forall(i in RES, j in RES) (
    flow[i,j] <= cap[i,j]
  );

% Flow conservation at intermediate reservoirs (all nodes except SOURCE and SINK)
constraint
  forall(k in RES where k != SOURCE /\ k != SINK) (
    sum(i in RES) (flow[i,k]) = sum(j in RES) (flow[k,j])
  );

% Define total_flow as net outflow from SOURCE (equivalently net inflow to SINK in a feasible flow)
constraint
  total_flow = sum(j in RES) (flow[SOURCE,j]) - sum(i in RES) (flow[i,SOURCE]);

% Enforce same total_flow via net inflow to SINK (tightens the model / improves propagation)
constraint
  total_flow = sum(i in RES) (flow[i,SINK]) - sum(j in RES) (flow[SINK,j]);


% Objective
solve maximize total_flow;
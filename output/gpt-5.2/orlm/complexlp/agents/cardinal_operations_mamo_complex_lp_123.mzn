% Parameters
int: N = 9;                         % number of reservoirs (nodes)
set of int: V = 0..N-1;             % node index set
int: source = 0;                    % source reservoir
int: sink = 8;                      % destination reservoir

array[V, V] of int: cap =           % pipeline capacities (0 => no arc)
[
  % to:   0  1  2  3  4  5  6  7  8
  /*0*/ [ 0, 6,16,12,16, 3, 9, 3,13],
  /*1*/ [ 2, 0, 0,20,13, 7,20,11,13],
  /*2*/ [ 4,15, 0,14,13, 5,12,14,16],
  /*3*/ [ 1, 0, 2, 0, 8, 7,11,14,16],
  /*4*/ [ 4,19, 7,14, 0, 1,20,14,16],
  /*5*/ [ 0, 0,14, 4,17, 0, 2,20, 9],
  /*6*/ [12,19, 3, 3, 0, 0, 0,13, 3],
  /*7*/ [ 8,19,16, 4, 6,13, 9, 0,15],
  /*8*/ [11, 6, 0, 6,10, 9, 3, 1, 0]
];

int: total_cap = sum(i,j in V)(cap[i,j]); % safe upper bound for total flow

% Variables
array[V, V] of var 0..total_cap: flow;    % flow on each directed arc (i->j)
var 0..total_cap: max_flow;               % total flow sent from source to sink

% Constraints
%--------------------------------------------------------------------------
% Capacity feasibility (includes forbidding flow on non-existing arcs via cap=0)
%--------------------------------------------------------------------------
constraint
  forall(i,j in V)(
    flow[i,j] <= cap[i,j]
  );

%--------------------------------------------------------------------------
% Flow conservation at transshipment nodes (neither source nor sink)
%--------------------------------------------------------------------------
constraint
  forall(v in V where v != source /\ v != sink)(
    sum(i in V)(flow[i,v]) = sum(j in V)(flow[v,j])
  );

%--------------------------------------------------------------------------
% Define max_flow as net outflow from the source (value of the flow)
%--------------------------------------------------------------------------
constraint
  max_flow =
    sum(j in V)(flow[source,j]) - sum(i in V)(flow[i,source]);

% Objective
solve maximize max_flow;

output ["max_flow = ", show(max_flow), "\n"];
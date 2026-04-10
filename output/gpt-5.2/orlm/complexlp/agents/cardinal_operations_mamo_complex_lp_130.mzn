% Parameters
int: N = 8;                          % number of nodes
set of int: Nodes = 0..N-1;          % node index set
int: Source = 0;                     % source node
int: Sink   = 7;                     % sink (destination) node

% Capacity matrix cap[i,j] (in thousands of units); 0 means no arc i->j
array[Nodes, Nodes] of int: cap =
  [| 0,  3,  7,  2, 18, 18, 14, 10
   | 1,  0, 10, 16, 14,  0,  6, 10
   | 4,  0,  0,  7,  2,  2,  6, 10
   | 2,  3,  7,  0, 20,  8,  6, 10
   | 1, 20,  4,  8,  0, 13,  8,  1
   |16,  9, 17, 17, 11,  0,  7,  8
   | 3,  7, 14,  1, 20,  5,  0, 13
   | 0,  0,  0,  0,  0,  0,  0,  0 |];

int: MaxCap = max([cap[i,j] | i in Nodes, j in Nodes]);  % for bounding totals


% Variables
array[Nodes, Nodes] of var 0..MaxCap: flow;  % flow on arc i->j (0 if no arc)
var 0..(N*MaxCap): total_flow;               % total flow from Source to Sink


% Constraints
%----------------------------
% Capacity / bounding (element-wise)
%----------------------------
constraint
  forall(i in Nodes, j in Nodes) (
    flow[i,j] <= cap[i,j]
  );

%----------------------------
% Arc feasibility / structure
%----------------------------
% Enforce that non-existing arcs (cap=0) carry zero flow
constraint
  forall(i in Nodes, j in Nodes where cap[i,j] = 0) (
    flow[i,j] = 0
  );

%----------------------------
% Flow conservation (all intermediate nodes)
%----------------------------
constraint
  forall(k in Nodes where k != Source /\ k != Sink) (
    sum(i in Nodes)(flow[i,k]) = sum(j in Nodes)(flow[k,j])
  );

%----------------------------
% Source/Sink flow balance
%----------------------------
% Define total_flow as the net flow leaving the Source (equivalently entering Sink)
constraint
  total_flow = sum(j in Nodes)(flow[Source,j]) - sum(i in Nodes)(flow[i,Source]);

% Ensure Source has no incoming flow (optional strengthening; does not change optimum)
constraint
  sum(i in Nodes)(flow[i,Source]) = 0;

% Ensure Sink has no outgoing flow (optional strengthening; does not change optimum)
constraint
  sum(j in Nodes)(flow[Sink,j]) = 0;

% Match total_flow to net inflow at Sink (consistency check / strengthening)
constraint
  total_flow = sum(i in Nodes)(flow[i,Sink]) - sum(j in Nodes)(flow[Sink,j]);


% Objective
solve maximize total_flow;

output ["max_flow = ", show(total_flow), "\n"];
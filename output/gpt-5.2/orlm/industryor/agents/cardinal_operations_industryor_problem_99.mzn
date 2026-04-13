% Parameters
%------------------------------------------------------------
% Node indexing: 1=A, 2=B, 3=C, 4=D, 5=E
%------------------------------------------------------------
int: nNodes = 5;
set of int: NODES = 1..nNodes;

int: A = 1;
int: B = 2;
int: C = 3;
int: D = 4;
int: E = 5;

% Bandwidth matrix (0 means no direct connection)
array[NODES, NODES] of int: bw =
  [|  0, 90, 85,  0, 65
   | 95,  0, 70, 65, 34
   | 60,  0,  0, 88, 80
   | 67, 30, 25,  0, 84
   |  0, 51,  0, 56,  0 |];

% Upper bound for bandwidth (for variable bounding)
int: maxBW = max([bw[i,j] | i in NODES, j in NODES]);

% Variables
%------------------------------------------------------------
% x[i,j] = 1 if the path uses directed arc i->j, else 0
array[NODES, NODES] of var 0..1: x;

% Order/position of node in the selected path (used to eliminate loops)
array[NODES] of var 0..nNodes: pos;

% Bottleneck bandwidth (minimum bandwidth along chosen link)
var 0..maxBW: bottleneck;

% Constraints
%------------------------------------------------------------
% Feasibility of selected arcs: can only use existing links
%------------------------------------------------------------
constraint
  forall(i in NODES, j in NODES where i != j) (
    (bw[i,j] = 0) -> (x[i,j] = 0)
  );

% Disallow self-loops explicitly
constraint
  forall(i in NODES) (
    x[i,i] = 0
  );

%------------------------------------------------------------
% Flow/path structure constraints: single simple directed path
% from A to E (must pass through C)
%------------------------------------------------------------

% Out-degree constraints
constraint sum(j in NODES)(x[A,j]) = 1;   % A has exactly one outgoing arc
constraint sum(j in NODES)(x[E,j]) = 0;   % E has no outgoing arc

% In-degree constraints
constraint sum(i in NODES)(x[i,A]) = 0;   % A has no incoming arc
constraint sum(i in NODES)(x[i,E]) = 1;   % E has exactly one incoming arc

% Flow conservation for intermediate nodes (including C):
% if a node is used, it has 1 in and 1 out; if not used, 0 in and 0 out.
constraint
  forall(v in NODES diff {A,E}) (
    sum(i in NODES)(x[i,v]) = sum(j in NODES)(x[v,j])
  );

% Ensure C is on the path (i.e., it is used)
constraint sum(i in NODES)(x[i,C]) = 1;
constraint sum(j in NODES)(x[C,j]) = 1;

% Prevent selecting both directions between a pair (strengthens "no loops")
constraint
  forall(i in NODES, j in NODES where i < j) (
    x[i,j] + x[j,i] <= 1
  );

%------------------------------------------------------------
% Subtour elimination / acyclicity using node order (MTZ-style)
%------------------------------------------------------------

% Fix positions of endpoints to anchor the ordering
constraint pos[A] = 1;
constraint pos[E] = nNodes;

% Nodes not used in the path can have position 0; used nodes have pos >= 1
% Using incoming flow to indicate whether a node is used (A is fixed separately).
constraint
  forall(v in NODES) (
    pos[v] <= nNodes * sum(i in NODES)(x[i,v])
  );

% If arc i->j is used then pos[j] >= pos[i] + 1 (eliminates cycles)
constraint
  forall(i in NODES, j in NODES where i != j) (
    pos[j] >= pos[i] + 1 - nNodes * (1 - x[i,j])
  );

%------------------------------------------------------------
% Bottleneck bandwidth definition: bottleneck <= bw on every used arc,
% and equals the minimum bandwidth along the chosen path at optimum.
%------------------------------------------------------------
constraint
  forall(i in NODES, j in NODES where i != j) (
    bottleneck <= bw[i,j] + maxBW * (1 - x[i,j])
  );

% Ensure bottleneck is supported by at least one used arc (tightening)
constraint
  exists(i in NODES, j in NODES where i != j) (
    x[i,j] = 1 /\ bottleneck <= bw[i,j]
  );

% Objective
solve maximize bottleneck;
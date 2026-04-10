% Parameters
int: N = 5;
set of int: Nodes = 1..N;

int: A = 1;
int: B = 2;
int: C = 3;
int: D = 4;
int: E = 5;

array[Nodes, Nodes] of int: bw =
  array2d(Nodes, Nodes,
  [
    0, 90, 85, 0, 65,
    95, 0, 70, 65, 34,
    60, 0, 0, 88, 80,
    67, 30, 25, 0, 84,
    0, 51, 0, 56, 0
  ]);

int: MaxBW = max([bw[i,j] | i in Nodes, j in Nodes]);

% Variables
array[Nodes, Nodes] of var 0..1: x;      % x[i,j]=1 if arc i->j is used in the path
array[Nodes] of var 0..1: y;             % y[v]=1 if node v is on the path
var 0..MaxBW: z;                         % bottleneck bandwidth (minimum bw along selected arcs)

% Constraints
constraint forall(i in Nodes)(x[i,i] = 0);

% Only allow selecting existing directed links (bw > 0)
constraint forall(i in Nodes, j in Nodes where i != j)(
  x[i,j] <= bool2int(bw[i,j] > 0)
);

% Flow conservation to form a simple A->E path
constraint sum(j in Nodes)(x[A,j]) = 1;
constraint sum(i in Nodes)(x[i,A]) = 0;

constraint sum(i in Nodes)(x[i,E]) = 1;
constraint sum(j in Nodes)(x[E,j]) = 0;

constraint forall(v in Nodes where v != A /\ v != E)(
  sum(i in Nodes)(x[i,v]) = sum(j in Nodes)(x[v,j])
);

% No loops / no revisits: at most one incoming and at most one outgoing per node
constraint forall(v in Nodes)(
  sum(i in Nodes)(x[i,v]) <= 1 /\
  sum(j in Nodes)(x[v,j]) <= 1
);

% Link the node-on-path indicator
constraint y[A] = 1;
constraint y[E] = 1;
constraint forall(v in Nodes)(
  y[v] >= sum(i in Nodes)(x[i,v]) /\
  y[v] >= sum(j in Nodes)(x[v,j])
);

% Must pass through service node C
constraint y[C] = 1;

% Bottleneck definition: z is <= every used arc bandwidth, and equals the minimum on the path
constraint forall(i in Nodes, j in Nodes where i != j)(
  z <= bw[i,j] + MaxBW * (1 - x[i,j])
);
constraint forall(i in Nodes, j in Nodes where i != j)(
  z >= bw[i,j] - MaxBW * (1 - x[i,j])
);

% Objective
solve maximize z;
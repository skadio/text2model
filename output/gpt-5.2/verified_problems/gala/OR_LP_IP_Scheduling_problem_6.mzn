include "globals.mzn";

%======================
% Input data
%======================
int: n;                         % number of nodes
int: num_edges;                 % number of arcs
array[1..num_edges, 1..2] of int: E;   % E[e,1]=tail, E[e,2]=head
array[1..num_edges] of int: a;         % capacities
int: s;                         % source
int: t;                         % sink

set of int: N = 1..n;
set of int: EDGES = 1..num_edges;

% Basic sanity (optional, but safe)
constraint forall(e in EDGES)(
  E[e,1] in N /\ E[e,2] in N /\ a[e] >= 0
);

%======================
% Decision variables
%======================
array[EDGES] of var 0..max(a): f;   % flow on each arc

% Capacity constraints
constraint forall(e in EDGES)( f[e] <= a[e] );

% Flow conservation at intermediate nodes
constraint forall(v in N where v != s /\ v != t)(
  sum(e in EDGES where E[e,2] = v)(f[e]) = sum(e in EDGES where E[e,1] = v)(f[e])
);

% Objective: maximize total flow out of source (equals into sink by conservation)
var 0..sum(a): total_flow = sum(e in EDGES where E[e,1] = s)(f[e]);

solve maximize total_flow;

output [
  "total_flow = ", show(total_flow), "\n",
  "f = ", show(f), "\n"
];
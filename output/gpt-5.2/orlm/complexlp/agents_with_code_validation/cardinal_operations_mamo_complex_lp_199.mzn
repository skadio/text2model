% Parameters
int: nV = 10;                         % number of vertices
set of int: V = 1..nV;                % vertex indices (1=a, 2=b, ..., 10=j)

% Vertex name mapping (for readability)
array[V] of string: vname =
  ["a","b","c","d","e","f","g","h","i","j"];

% Edges as undirected pairs (eu[e], ev[e])
% Outer pentagon edges: (a-b, b-c, c-d, d-e, e-a)
% Spokes to inner K5: (a-f, b-g, c-h, d-i, e-j)
% Inner K5 on {f,g,h,i,j}: all pairs
int: nE = 20;                         % number of edges
set of int: E = 1..nE;                % edge indices

array[E] of int: eu =                 % edge endpoint u
  [ 1, 2, 3, 4, 5,   1, 2, 3, 4, 5,   6, 6, 6, 6,   7, 7, 7,   8, 8,   9 ];
array[E] of int: ev =                 % edge endpoint v
  [ 2, 3, 4, 5, 1,   6, 7, 8, 9, 10,  7, 8, 9, 10,  8, 9, 10,  9, 10,  10 ];

% Variables
array[V] of var 0..1: inCover;        % 1 if vertex is chosen in the cover, else 0
var 0..nV: coverSize;                 % size of the vertex cover (objective)

% Constraints
% Cover size definition (counts selected vertices)
constraint coverSize = sum(v in V)(inCover[v]);

% Vertex cover feasibility: every edge is covered by at least one endpoint
constraint forall(e in E)(
  inCover[eu[e]] + inCover[ev[e]] >= 1
);

% Objective
solve minimize coverSize;
% Minimum Vertex Cover for the described graph (10 vertices: a..j)
% Data embedded directly in the model.

include "globals.mzn";

int: n = 10;
set of int: V = 1..n;

% Vertex indices: 1=a,2=b,3=c,4=d,5=e,6=f,7=g,8=h,9=i,10=j
array[V] of string: name = ["a","b","c","d","e","f","g","h","i","j"];

% Undirected edges (each edge listed once as (u,v) with u < v)
% Outer pentagon edges:
% a-b, b-c, c-d, d-e, e-a
% Spokes to inner vertices:
% a-f, b-g, c-h, d-i, e-j
% Inner K5 on f,g,h,i,j
array[1..20] of int: U = [
  1, 2, 3, 4, 1,   % a-b, b-c, c-d, d-e, e-a (U side)
  1, 2, 3, 4, 5,   % a-f, b-g, c-h, d-i, e-j (U side)
  6, 6, 6, 6, 7, 7, 7, 8, 8, 9  % K5 (U side)
];
array[1..20] of int: W = [
  2, 3, 4, 5, 5,   % a-b, b-c, c-d, d-e, e-a (W side)
  6, 7, 8, 9, 10,  % a-f, b-g, c-h, d-i, e-j (W side)
  7, 8, 9, 10, 8, 9, 10, 9, 10, 10 % K5 (W side)
];

int: m = length(U);

% Decision: in_cover[v] = true if vertex v is chosen in the vertex cover
array[V] of var bool: in_cover;

% Every edge must be incident to at least one chosen vertex
constraint
  forall(e in 1..m) (
    in_cover[U[e]] \/ in_cover[W[e]]
  );

% Objective: minimize size of vertex cover
var int: cover_size = sum(v in V)(bool2int(in_cover[v]));
solve minimize cover_size;

output [
  "Minimum vertex cover size = ", show(cover_size), "\n",
  "Vertices in cover: ",
  concat([ if fix(in_cover[v]) then name[v] ++ " " else "" endif | v in V ]),
  "\n"
];
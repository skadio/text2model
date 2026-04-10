% Parameters
% Number of vertices (a..j)
int: nV = 10;
set of int: V = 1..nV;

% Helper mapping (for readability in comments):
% 1=a, 2=b, 3=c, 4=d, 5=e, 6=f, 7=g, 8=h, 9=i, 10=j

% Undirected edges, embedded from the description.
% Outer pentagon: (a-b), (b-c), (c-d), (d-e), (e-a)
% Spokes to inner vertices: (a-f), (b-g), (c-h), (d-i), (e-j)
% Inner K5 on f..j: all pairs among {f,g,h,i,j}
int: nE = 20;
set of int: E = 1..nE;

array[E] of int: u = [
  1, 2, 3, 4, 5,   % (a-b),(b-c),(c-d),(d-e),(e-a)
  1, 2, 3, 4, 5,   % (a-f),(b-g),(c-h),(d-i),(e-j)
  6, 6, 6, 6,      % (f-g),(f-h),(f-i),(f-j)
  7, 7, 7,         % (g-h),(g-i),(g-j)
  8, 8,            % (h-i),(h-j)
  9                % (i-j)
];

array[E] of int: v = [
  2, 3, 4, 5, 1,
  6, 7, 8, 9, 10,
  7, 8, 9, 10,
  8, 9, 10,
  9, 10,
  10
];

% Variables
% in_cover[i] = 1 if vertex i is selected in the vertex cover, else 0
array[V] of var 0..1: in_cover;

% Total size of the vertex cover
var 0..nV: cover_size;

% Constraints
% Link cover_size to the chosen vertices
constraint cover_size = sum(i in V)(in_cover[i]);

% Vertex cover condition: every edge must have at least one endpoint selected
constraint
  forall(e in E) (
    in_cover[u[e]] + in_cover[v[e]] >= 1
  );

% Objective
solve minimize cover_size;

output [
  "min_vertex_cover_size = ", show(cover_size), "\n",
  "selected_vertices(1=a..10=j) = ",
    show([i | i in V where fix(in_cover[i]) = 1]),
  "\n"
];
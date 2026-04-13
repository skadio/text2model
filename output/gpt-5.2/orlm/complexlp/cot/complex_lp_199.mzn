% Parameters (with values embedded)
int: n = 10;
set of int: V = 1..n;

% Vertex mapping: 1=a, 2=b, 3=c, 4=d, 5=e, 6=f, 7=g, 8=h, 9=i, 10=j
int: m = 20;
set of int: E = 1..m;

array[E] of int: u = [
  1,  % a-f
  1,  % a-e
  1,  % a-b
  2,  % b-g
  2,  % b-c
  3,  % c-h
  3,  % c-d
  4,  % d-i
  4,  % d-e
  5,  % e-j
  6,  % f-g
  6,  % f-h
  6,  % f-i
  6,  % f-j
  7,  % g-h
  7,  % g-i
  7,  % g-j
  8,  % h-i
  8,  % h-j
  9   % i-j
];

array[E] of int: v = [
  6,  % a-f
  5,  % a-e
  2,  % a-b
  7,  % b-g
  3,  % b-c
  8,  % c-h
  4,  % c-d
  9,  % d-i
  5,  % d-e
  10, % e-j
  7,  % f-g
  8,  % f-h
  9,  % f-i
  10, % f-j
  8,  % g-h
  9,  % g-i
  10, % g-j
  9,  % h-i
  10, % h-j
  10  % i-j
];

% Variables
array[V] of var 0..1: x; % x[i]=1 iff vertex i is in the cover

% Constraints
constraint
  forall(e in E) (
    x[u[e]] + x[v[e]] >= 1
  );

% Objective
solve minimize sum(i in V)(x[i]);

output [
  "min_vertex_cover_size = ", show(sum(i in V)(x[i])), "\n",
  "cover_vertices (1=a..10=j) = ", show([i | i in V where fix(x[i]) = 1]), "\n",
  "cover_bits = ", show([x[i] | i in V]), "\n"
];
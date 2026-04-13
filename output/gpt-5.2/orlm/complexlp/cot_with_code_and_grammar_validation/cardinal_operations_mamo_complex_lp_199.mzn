% Minimum Vertex Cover for the described graph

int: n = 10;
set of int: V = 1..n;

% Vertex mapping: 1=a, 2=b, 3=c, 4=d, 5=e, 6=f, 7=g, 8=h, 9=i, 10=j
% Edges (undirected), listed once each:
% Outer pentagon edges: (a,b),(b,c),(c,d),(d,e),(e,a)
% Spokes: (a,f),(b,g),(c,h),(d,i),(e,j)
% Inner K5 on {f,g,h,i,j}: all pairs

int: m = 20;
set of int: E = 1..m;

array[E] of int: u = [
  1, 2, 3, 4, 5,     % (a,b),(b,c),(c,d),(d,e),(e,a)
  1, 2, 3, 4, 5,     % (a,f),(b,g),(c,h),(d,i),(e,j)
  6, 6, 6, 6,        % (f,g),(f,h),(f,i),(f,j)
  7, 7, 7,           % (g,h),(g,i),(g,j)
  8, 8,              % (h,i),(h,j)
  9                  % (i,j)
];

array[E] of int: v = [
  2, 3, 4, 5, 1,
  6, 7, 8, 9, 10,
  7, 8, 9, 10,
  8, 9, 10,
  9, 10,
  10
];

% Decision variables: x[i]=1 if vertex i is chosen in the cover
array[V] of var 0..1: x;

% Every edge must be covered
constraint forall(e in E) (
  x[u[e]] + x[v[e]] >= 1
);

solve minimize sum(i in V)(x[i]);
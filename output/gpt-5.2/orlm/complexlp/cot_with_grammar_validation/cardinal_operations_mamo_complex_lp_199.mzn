% Parameters
int: N = 10;
set of int: V = 1..N;

% Map: 1=a,2=b,3=c,4=d,5=e,6=f,7=g,8=h,9=i,10=j
int: M = 15;
set of int: E = 1..M;

array[E] of int: u = [ 1, 2, 3, 4, 5,   1, 2, 3, 4, 5,   6, 6, 6, 6, 7 ];
array[E] of int: v = [ 6, 7, 8, 9,10,   2, 3, 4, 5, 1,   7, 8, 9,10, 8 ];
% Edges:
% Outer pentagon: (a-f),(b-g),(c-h),(d-i),(e-j)
% Outer cycle:    (a-b),(b-c),(c-d),(d-e),(e-a)
% K5 among f..j:  (f-g),(f-h),(f-i),(f-j),(g-h) plus remaining edges implied? -> include all:
% Actually K5 requires 10 edges; add all pairs among 6..10:
int: M2 = 10;
set of int: EK = 1..M2;
array[EK] of int: ku = [6,6,6,6, 7,7,7, 8,8, 9];
array[EK] of int: kv = [7,8,9,10, 8,9,10, 9,10, 10];

% Variables
array[V] of var 0..1: x; % x[i]=1 iff vertex i is in the cover
var 0..N: cover_size;

% Constraints
constraint cover_size = sum(i in V)(x[i]);

constraint forall(e in E)(
  x[u[e]] + x[v[e]] >= 1
);

constraint forall(e in EK)(
  x[ku[e]] + x[kv[e]] >= 1
);

% Objective
solve minimize cover_size;
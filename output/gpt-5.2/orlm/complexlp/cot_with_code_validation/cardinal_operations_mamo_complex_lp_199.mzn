% Parameters
int: n = 10;
set of int: V = 1..n;

% Vertex mapping (for reference): 1=a, 2=b, 3=c, 4=d, 5=e, 6=f, 7=g, 8=h, 9=i, 10=j
int: m = 15;
array[1..m, 1..2] of int: E = array2d(1..m, 1..2, [
  1,6,   % a-f
  1,5,   % a-e
  1,2,   % a-b
  2,7,   % b-g
  2,3,   % b-c
  3,8,   % c-h
  3,4,   % c-d
  4,9,   % d-i
  4,5,   % d-e
  5,10,  % e-j
  6,7,   % f-g
  6,8,   % f-h
  6,9,   % f-i
  6,10,  % f-j
  7,8    % g-h
]);

% (Note) Problem statement says inner vertices f,g,h,i,j form K5, but only f-* and g-h are explicitly listed.
% This model uses exactly the edges provided in the description above.

% Variables
array[V] of var 0..1: x; % x[v]=1 if vertex v is in the cover

% Constraints
constraint
  forall(e in 1..m) (
    x[E[e,1]] + x[E[e,2]] >= 1
  );

% Objective
solve minimize sum(v in V)(x[v]);
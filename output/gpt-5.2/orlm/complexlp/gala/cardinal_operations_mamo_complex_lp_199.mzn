include "globals.mzn";

% Vertex cover on a 10-vertex graph labeled a..j as 1..10.
% 1=a,2=b,3=c,4=d,5=e,6=f,7=g,8=h,9=i,10=j

int: n = 10;
set of int: V = 1..n;

% Edges as described:
% Outer pentagon-ish connections with specified adjacencies:
% a-f, a-e, a-b
% b-g, b-c
% c-h, c-d
% d-i, d-e
% e-j
% plus K5 among inner vertices f,g,h,i,j (6..10): all pairs.
int: m = 20;
array[1..m] of int: u = [
  1, 1, 1,   % a-f, a-e, a-b
  2, 2,      % b-g, b-c
  3, 3,      % c-h, c-d
  4, 4,      % d-i, d-e
  5,         % e-j
  6, 6, 6, 6,  % K5 edges from f to g,h,i,j
  7, 7, 7,     % from g to h,i,j
  8, 8,        % from h to i,j
  9            % from i to j
];
array[1..m] of int: v = [
  6, 5, 2,   % a-f, a-e, a-b
  7, 3,      % b-g, b-c
  8, 4,      % c-h, c-d
  9, 5,      % d-i, d-e
  10,        % e-j
  7, 8, 9, 10, % f-g,f-h,f-i,f-j
  8, 9, 10,    % g-h,g-i,g-j
  9, 10,       % h-i,h-j
  10           % i-j
];

% Decision: in_cover[i] = 1 if vertex i is in the cover
array[V] of var 0..1: in_cover;

% Each edge must be incident to at least one chosen vertex
constraint forall(e in 1..m) (
  in_cover[u[e]] + in_cover[v[e]] >= 1
);

% Objective: minimize cover size
var 0..n: cover_size = sum(i in V)(in_cover[i]);
solve minimize cover_size;

function string: name(int: i) =
  if i=1 then "a" elseif i=2 then "b" elseif i=3 then "c" elseif i=4 then "d" elseif i=5 then "e"
  elseif i=6 then "f" elseif i=7 then "g" elseif i=8 then "h" elseif i=9 then "i" else "j" endif;

output [
  "Minimum vertex cover size (nearest integer): ", show(cover_size), "\n",
  "Vertices in cover: {",
  concat([ if fix(in_cover[i])=1 then name(i) ++ " " else "" endif | i in V ]),
  "}\n",
  "in_cover (a..j as 1..10) = ", show(in_cover), "\n"
];
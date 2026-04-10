% Parameters
int: N = 6;
set of int: Cities = 0..N-1;

int: s = 0;
int: t = 5;

array[Cities, Cities] of int: cap =
array2d(Cities, Cities,
[
  % to: 0  1  2  3  4  5
       0, 6, 8, 1, 9, 8,   % from 0
      16, 0, 6, 0,12,16,   % from 1
       7,16, 0,20,17, 9,   % from 2
       3,11,14, 0, 7, 0,   % from 3
       6,19,19, 3, 0,20,   % from 4
      20, 5,16,12, 2, 0    % from 5
]);

int: U = sum(i in Cities, j in Cities)(cap[i,j]);

% Variables
array[Cities, Cities] of var 0..U: f;
var 0..U: maxflow;

% Constraints
constraint
  forall(i in Cities, j in Cities)(
    f[i,j] <= cap[i,j]
  );

constraint
  forall(i in Cities)(
    f[i,i] = 0
  );

constraint
  forall(v in Cities where v != s /\ v != t)(
    sum(i in Cities)(f[i,v]) = sum(j in Cities)(f[v,j])
  );

constraint
  maxflow = sum(j in Cities)(f[s,j]) - sum(i in Cities)(f[i,s]);

constraint
  maxflow = sum(i in Cities)(f[i,t]) - sum(j in Cities)(f[t,j]);

% Objective
solve maximize maxflow;
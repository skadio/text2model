% Parameters
int: n;
array[1..n, 1..n] of int: puzzle;

% Variables
array[1..n, 1..n] of var bool: painted;

% Constraints
constraint
  forall(i in 1..n, j in 1..n where puzzle[i,j] >= 0) (
    sum([ bool2int(painted[r,c]) |
          r in max(1,i-1)..min(n,i+1),
          c in max(1,j-1)..min(n,j+1) ]) = puzzle[i,j]
  );

% Objective
solve satisfy;
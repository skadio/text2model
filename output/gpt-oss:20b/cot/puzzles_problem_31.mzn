% Parameters
int: n;
array[1..n,1..n] of int: puzzle; % -1 for unknown cells, non‑negative for clues

% Variables
array[1..n,1..n] of var 0..1: painted;

% Constraints
constraint forall(i in 1..n, j in 1..n where puzzle[i,j] >= 0) (
    painted[i,j] == 1
);
constraint forall(i in 1..n, j in 1..n where puzzle[i,j] >= 0) (
    sum(k in i-1..i+1, l in j-1..j+1 where k>=1 /\ k<=n /\ l>=1 /\ l<=n) (painted[k,l]) == puzzle[i,j]
);

% Objective
solve satisfy;
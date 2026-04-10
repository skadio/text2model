% Parameters
int: r;
int: c;
array[1..r, 1..c] of int: puzzle;

int: N = r * c;
set of int: R = 1..r;
set of int: C = 1..c;
set of int: K = 1..N;

% Variables
array[R, C] of var 0..N: x;                % value in each cell (0 means unused/blocked if any)
array[K, R, C] of var bool: at;            % at[k,i,j] = true iff x[i,j] = k

% Constraints
% Cell domain: keep given clues, otherwise allow 1..N (no 0 in standard Hidato)
constraint
  forall(i in R, j in C) (
    if puzzle[i,j] > 0 then
      x[i,j] = puzzle[i,j]
    else
      x[i,j] >= 1
    endif
  );

% Link x and at: each number appears in exactly one cell; each cell has exactly one number
constraint
  forall(k in K) (
    sum(i in R, j in C)(bool2int(at[k,i,j])) = 1
  );

constraint
  forall(i in R, j in C) (
    sum(k in K)(bool2int(at[k,i,j])) = 1
  );

constraint
  forall(i in R, j in C, k in K) (
    at[k,i,j] <-> (x[i,j] = k)
  );

% Consecutive adjacency: k and k+1 must be in neighboring (8-connected) cells
constraint
  forall(k in 1..N-1, i in R, j in C) (
    at[k,i,j] ->
      sum(ii in max(1,i-1)..min(r,i+1), jj in max(1,j-1)..min(c,j+1))
        (bool2int(at[k+1,ii,jj])) = 1
  );

% Objective
solve satisfy;
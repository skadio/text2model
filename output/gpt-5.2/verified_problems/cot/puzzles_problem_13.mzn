% Parameters
int: r;
int: c;
array[1..r, 1..c] of int: puzzle;

% Variables
int: N = r * c;
array[1..r, 1..c] of var 1..N: x;

% Constraints
constraint forall(i in 1..r, j in 1..c) (
  (puzzle[i,j] > 0) -> (x[i,j] = puzzle[i,j])
);

constraint all_different([ x[i,j] | i in 1..r, j in 1..c ]);

constraint forall(i in 1..r, j in 1..c) (
  let { var int: v = x[i,j] } in
  ((v > 1) ->
    exists(ii in max(1,i-1)..min(r,i+1), jj in max(1,j-1)..min(c,j+1)) (
      (ii != i \/ jj != j) /\ x[ii,jj] = v - 1
    )
  )
);

constraint forall(i in 1..r, j in 1..c) (
  let { var int: v = x[i,j] } in
  ((v < N) ->
    exists(ii in max(1,i-1)..min(r,i+1), jj in max(1,j-1)..min(c,j+1)) (
      (ii != i \/ jj != j) /\ x[ii,jj] = v + 1
    )
  )
);

% Objective
solve satisfy;
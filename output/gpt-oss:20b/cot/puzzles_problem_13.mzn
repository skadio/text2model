% Parameters
int: r;
int: c;
array2d(1..r, 1..c) of int: puzzle;

% Variables
array2d(1..r, 1..c) of var 1..(r*c): grid;

% Constraints
constraint all_different([grid[i,j] | i in 1..r, j in 1..c]);

constraint forall(i in 1..r, j in 1..c) (
    puzzle[i,j] > 0 -> grid[i,j] = puzzle[i,j]
);

constraint forall(i in 1..r, j in 1..c) (
    grid[i,j] < r*c ->
    exists(ni in max(1,i-1)..min(r,i+1), nj in max(1,j-1)..min(c,j+1)) (
        (ni != i \/ nj != j) /\ (grid[ni,nj] = grid[i,j] + 1)
    )
);

% Objective
solve satisfy;
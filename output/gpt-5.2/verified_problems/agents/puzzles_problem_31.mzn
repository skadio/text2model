% Parameters
int: n;                                    % Grid size (n rows, n columns)
array[1..n, 1..n] of var int: puzzle;      % Puzzle grid entries: clue number (0..9) or unknown (e.g., -1)

% Variables
array[1..n, 1..n] of var 0..1: painted;    % 1 if the cell is painted/filled, 0 otherwise

% Auxiliary variables
array[1..n, 1..n] of var 0..9: neigh_count; % # painted cells in the 3x3 neighborhood incl. itself

% Constraints

% Neighborhood painted count definition (3x3 around each cell, clipped at borders)
constraint
  forall(i in 1..n, j in 1..n) (
    neigh_count[i,j] =
      sum(ii in max(1,i-1)..min(n,i+1),
          jj in max(1,j-1)..min(n,j+1)) (
        painted[ii,jj]
      )
  );

% Enforce clue satisfaction: if a cell is a clue (0..9), its neighborhood count must match it.
% Assumes unknown cells are encoded with a value outside 0..9 in `puzzle` (e.g., -1).
constraint
  forall(i in 1..n, j in 1..n) (
    (puzzle[i,j] >= 0 /\ puzzle[i,j] <= 9) ->
      (neigh_count[i,j] = puzzle[i,j])
  );

% Objective
solve satisfy;
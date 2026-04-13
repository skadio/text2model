include "globals.mzn";

int: n;
array[1..n, 1..n] of int: puzzle; % use -1 for unknown (X), 0..9 for clues (or up to 9)

array[1..n, 1..n] of var bool: painted;

% Enforce each clue: sum of painted cells in its 3x3 neighborhood (including itself) equals clue value.
constraint
  forall(i in 1..n, j in 1..n where puzzle[i,j] >= 0) (
    let {
      set of int: I = {ii | ii in max(1,i-1)..min(n,i+1)},
      set of int: J = {jj | jj in max(1,j-1)..min(n,j+1)}
    } in
      sum(ii in I, jj in J)(bool2int(painted[ii,jj])) = puzzle[i,j]
  );

solve satisfy;

output [
  if painted[i,j] then "#" else "." endif ++
  if j = n then "\n" else "" endif
  | i in 1..n, j in 1..n
];
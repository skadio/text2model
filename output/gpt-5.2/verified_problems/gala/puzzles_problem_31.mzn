include "globals.mzn";

% Input
int: n;
array[1..n, 1..n] of int: puzzle;   % use -1 for unknown (X), 0..9 for clues

% Decision variables: 1 = painted, 0 = unpainted
array[1..n, 1..n] of var 0..1: painted;

% Each clue equals the number of painted cells in its 3x3 neighbourhood (including itself)
constraint
  forall(i in 1..n, j in 1..n where puzzle[i,j] != -1) (
    count(
      [ painted[r,c] | r in max(1,i-1)..min(n,i+1),
                       c in max(1,j-1)..min(n,j+1) ],
      1,
      puzzle[i,j]
    )
  );

solve satisfy;

output [
  "painted (1=filled,0=empty):\n",
  concat([ concat([ if fix(painted[i,j]) == 1 then "#" else "." endif
                    ++ if j == n then "\n" else "" endif
                  | j in 1..n ])
         | i in 1..n ])
];
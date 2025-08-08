include "globals.mzn";

int: n;                         % grid size (number of rows/columns)
array[1..n, 1..n] of int: puzzle;  % puzzle grid with clues (>= 0) or unknown cells (-1)
array[1..n, 1..n] of var 0..1: painted;  % 1 = painted; 0 = not painted

% For each cell with a clue, the number of painted cells in its 3x3 region must equal the clue
constraint
  forall(i in 1..n, j in 1..n where puzzle[i,j] >= 0) (
    let {
      array[int] of var 0..1: region = [
         painted[i2, j2]
         | i2 in max(1, i-1)..min(n, i+1),
           j2 in max(1, j-1)..min(n, j+1)
      ]
    } in 
      count(region, 1, puzzle[i,j])
  );

solve satisfy;

output [
  concat([ if painted[i,j] == 1 then "X " else ". " endif | j in 1..n ]) ++ "\n"
  | i in 1..n
];
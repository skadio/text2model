% Fill-a-Pix (Minesweeper-like) puzzle
% Data:
%   int: n;
%   array[1..n,1..n] of int: puzzle;  % -1 for unknown (X), 0..9 for clues

int: n;
array[1..n, 1..n] of int: puzzle;

array[1..n, 1..n] of var 0..1: paint;

constraint
  forall(i in 1..n, j in 1..n where puzzle[i,j] >= 0) (
    sum(r in max(1, i-1)..min(n, i+1),
        c in max(1, j-1)..min(n, j+1)) (
      paint[r,c]
    ) = puzzle[i,j]
  );

solve satisfy;

output [
  if fix(paint[i,j]) = 1 then "#" else "." endif ++
  if j = n then "\n" else "" endif
  | i in 1..n, j in 1..n
];
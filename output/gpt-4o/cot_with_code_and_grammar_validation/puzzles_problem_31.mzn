int: X = -1;

int: n;
array[1..n, 1..n] of int: puzzle;   % 0‥9 for clues, X for unknown cells

array[1..n, 1..n] of var 0..1: painted;   % 1 = painted, 0 = left blank

constraint
  forall(i in 1..n, j in 1..n where puzzle[i,j] >= 0) (
    sum([ painted[r,c] |
          r in max(1,i-1)..min(n,i+1),
          c in max(1,j-1)..min(n,j+1)
        ]) = puzzle[i,j]
  );

solve satisfy;
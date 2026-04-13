int: n;
array[1..n, 1..n] of int: puzzle;

array[1..n, 1..n] of var 0..1: paint;

constraint
  forall(r in 1..n, c in 1..n) (
    (puzzle[r, c] >= 0) ->
      (sum(rr in max(1, r - 1)..min(n, r + 1),
           cc in max(1, c - 1)..min(n, c + 1)) (paint[rr, cc]) = puzzle[r, c])
  );

solve satisfy;

output [ if fix(paint[r,c]) = 1 then "#" else "." endif ++ if c = n then "\n" else "" endif | r in 1..n, c in 1..n ];
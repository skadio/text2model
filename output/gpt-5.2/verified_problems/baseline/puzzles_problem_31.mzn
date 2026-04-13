int: n;

array[1..n, 1..n] of var int: puzzle;

array[1..n, 1..n] of var 0..1: paint;

constraint
  forall(i in 1..n, j in 1..n where fix(puzzle[i,j])) (
    let {
      int: r1 = max(1, i-1),
      int: r2 = min(n, i+1),
      int: c1 = max(1, j-1),
      int: c2 = min(n, j+1)
    } in
      sum(r in r1..r2, c in c1..c2)(paint[r,c]) = puzzle[i,j]
  );

solve satisfy;

output [
  if j = 1 then "\n" else "" endif ++
  if fix(paint[i,j]) /\ (paint[i,j] = 1) then "#" else "." endif
  | i in 1..n, j in 1..n
];
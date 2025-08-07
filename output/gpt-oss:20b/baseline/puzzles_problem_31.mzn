int: n;
array[1..n,1..n] of int: puzzle; % -1 for unknown, otherwise clue value

array[1..n,1..n] of var 0..1: painted;

% clue cells must be painted
constraint
  forall(i in 1..n, j in 1..n) (
    if puzzle[i][j] != -1 then
      painted[i][j] = 1
    else
      true
  );

% each clue cell must have exactly its value of painted cells in its 3x3 neighbourhood
constraint
  forall(i in 1..n, j in 1..n) (
    if puzzle[i][j] != -1 then
      let {
        int: clue = puzzle[i][j];
        set of int: rows = {max(1,i-1) .. min(n,i+1)};
        set of int: cols = {max(1,j-1) .. min(n,j+1)};
      } in
        sum([painted[r][c] | r in rows, c in cols]) = clue
    else
      true
  );

solve satisfy;

output [
  if j = 1 then "\n" else "" endif ++
  if painted[i][j] = 1 then "X" else "." endif
  | i in 1..n, j in 1..n
];
int: r;
int: c;
float: Z;
float: M;

set of int: ROWS = 1..r;
set of int: COLS = 1..c;

array[ROWS, COLS] of var float: cellValue;

constraint
  forall(i in ROWS, j in COLS) (
    cellValue[i,j] >= Z /\ cellValue[i,j] <= M
  );

% Leibmann five-point scheme (interior points)
constraint
  forall(i in 2..r-1, j in 2..c-1) (
    4.0 * cellValue[i,j] =
      cellValue[i-1,j] + cellValue[i+1,j] + cellValue[i,j-1] + cellValue[i,j+1]
  );

solve minimize cellValue[1,1];

output [
  "cellValue=\n"
] ++
[
  if j = 1 then "" else " " endif ++ show(cellValue[i,j]) ++ if j = c then "\n" else "" endif
  | i in ROWS, j in COLS
];
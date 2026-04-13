int: n;

array[1..n] of var 1..n: queens;

constraint
  forall(i in 1..n, j in i+1..n) (
    queens[i] != queens[j] /\
    abs(queens[i] - queens[j]) != j - i
  );

solve satisfy;

output [
  "queens = [", concat([show(queens[i]) ++ (if i < n then ", " else "" endif) | i in 1..n]), "];\n"
];
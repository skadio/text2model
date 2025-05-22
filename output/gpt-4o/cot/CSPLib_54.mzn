int: n;

array[1..n] of var 1..n: queens;

constraint
    % No two queens share the same column
    all_different(queens);

constraint
    % No two queens share the same (row + column) diagonal
    all_different([queens[i] + i | i in 1..n]);

constraint
    % No two queens share the same (row - column) diagonal
    all_different([queens[i] - i | i in 1..n]);

solve satisfy;
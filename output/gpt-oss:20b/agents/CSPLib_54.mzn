include "globals.mzn";

int: n;                            % board size (also number of queens)

% Decision variables: queens[i] is the column of the queen in row i
array[1..n] of var 1..n: queens;

% No two queens in the same column
constraint all_different(queens);

% No two queens on the same diagonal
constraint all_different([ queens[i] - i | i in 1..n ]);
constraint all_different([ queens[i] + i | i in 1..n ]);

solve satisfy;

output [
    "Queens positions: ", show(queens), "\n",
    "Board:\n",
    concat([ let {
        string row = concat([ if queens[i] == j then "Q" else "." endif | j in 1..n ])
    } in row ++ "\n" | i in 1..n ])
];
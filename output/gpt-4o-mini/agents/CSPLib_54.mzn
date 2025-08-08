include "globals.mzn";

int: n;  % Size of the chessboard and number of queens
array[1..n] of var 1..n: queens;  % Positions of the queens

% Constraints to ensure no two queens can attack each other
constraint all_different(queens);  % No two queens in the same column

% Diagonal constraints
constraint forall(i in 1..n)( 
    forall(j in i+1..n)( 
        abs(queens[i] - queens[j]) != j - i  % No two queens on the same diagonal
    )
);

% Solve & output
solve satisfy;
output [ "Queens' positions: ", show(queens), "\n" ];
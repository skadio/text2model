include "globals.mzn";

int: n;  % Size of the grid
array[1..n, 1..n] of var 0..1: painted;  % 0 for unpainted, 1 for painted
array[1..n, 1..n] of int: puzzle;         % grid with clues

% Constraints for each clue in the puzzle
constraint forall(i in 1..n, j in 1..n)(
    puzzle[i, j] > 0 -> (
        let {
            int: clue_value = puzzle[i, j];  % the clue value at (i, j)
            % Define the range for the surrounding cells
            array[1..3, 1..3] of var int: surrounding = 
                [ painted[i-1, j-1], painted[i-1, j], painted[i-1, j+1],
                  painted[i, j-1],   painted[i, j],   painted[i, j+1],
                  painted[i+1, j-1], painted[i+1, j], painted[i+1, j+1] ]
        } in
        constraint count(surrounding, 1, clue_value)  % count painted squares around the clue
    )
);

% Solve & output
solve satisfy;
output [ "Painted grid:\n", show(painted) ];
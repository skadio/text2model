% number of rows
int: n;
% clues in the grid
array[1..n, 1..n] of -1..9: puzzle;
% solution grid
array[1..n, 1..n] of var 0..1: grid;
% -1 represents a blank
int: X = -1; 

% satisfaction
solve satisfy;

% the number of neighboring painted squares must be equal to the value of the clue for every clue
constraint
    forall(i,j in 1..n) (
      (
       (puzzle[i,j] >= 0)
        ->
        puzzle[i,j] = sum(a,b in {-1,0,1} where 
            i+a > 0  /\ j+b >  0 /\
            i+a <= n /\ j+b <= n
         )
           (grid[i+a,j+b])
      )
    )
;

% output
output [
   if j = 1 then ",\n" else "," endif ++
     show(grid[i,j])
   | i, j in 1..n
]
++
["\n"]
;
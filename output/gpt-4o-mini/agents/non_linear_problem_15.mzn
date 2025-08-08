int: r;                  % Number of rows
int: c;                  % Number of columns
float: Z;                % Minimum value
float: M;                % Maximum value

% Variables
array[1..r, 1..c] of var Z..M: grid;  % Grid of values

% Constraints: Each cell is the average of its neighbors
constraint forall(i in 1..r, j in 1..c) (
    grid[i, j] = ( 
        (if i > 1 then grid[i-1, j] else 0.0) +  % top neighbor
        (if i < r then grid[i+1, j] else 0.0) +  % bottom neighbor
        (if j > 1 then grid[i, j-1] else 0.0) +  % left neighbor
        (if j < c then grid[i, j+1] else 0.0)   % right neighbor
    ) / (if i > 1 then 1 else 0) + 
      (if i < r then 1 else 0) + 
      (if j > 1 then 1 else 0) + 
      (if j < c then 1 else 0)
);

% Objective: Minimize the value at position (1,1)
var float: obj = grid[1, 1];
solve minimize obj;

% Output
output [ "Grid values:\n" ] ++ 
       [ show(grid[i, j) ++ " " | j in 1..c] ++ "\n" | i in 1..r ] ++ 
       [ "Minimum value at (1,1): ", show(obj), "\n" ];
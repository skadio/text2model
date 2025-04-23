% Parameters
int: r; % Number of rows in the grid
int: c; % Number of columns in the grid
array[1..r, 1..c] of int: puzzle; % Hidato puzzle grid where 0 represents an empty cell and a positive integer represents a filled cell

% Variables
% No additional variables are needed for this problem as the puzzle grid itself is the variable that needs to be solved.

% Constraints

% Find the start and end numbers in the puzzle
int: start = min([ puzzle[i,j] | i in 1..r, j in 1..c where puzzle[i,j] > 0 ]);
int: end = max([ puzzle[i,j] | i in 1..r, j in 1..c where puzzle[i,j] > 0 ]);

% Ensure that all numbers from start to end are present in the puzzle
constraint forall(i in start..end)( 
  exists(ij in { (i,j) | i in 1..r, j in 1..c }(puzzle[ij[1],ij[2]] = i))
);

% Ensure that each number from start to end is adjacent to its predecessor and successor
constraint forall(i in start+1..end-1)(
  let { 
    set of int: row = { k | k in 1..r where exists(j in 1..c)(puzzle[k,j] = i) },
    set of int: col = { k | k in 1..c where exists(j in 1..r)(puzzle[j,k] = i) }
  } in
  exists(dir_row in { -1, 0, 1 }, dir_col in { -1, 0, 1 })(
    (exists(j in max(1,row+dir_row)..min(r,row+dir_row), k in max(1,col+dir_col)..min(c,col+dir_col))(puzzle[j,k] = i-1) \/ 
     exists(j in max(1,row+dir_row)..min(r,row+dir_row), k in max(1,col+dir_col)..min(c,col+dir_col))(puzzle[j,k] = i+1))
  )
);

% Ensure that the start number is adjacent to the number start+1 and the end number is adjacent to the number end-1
constraint 
  let { 
    set of int: row_start = { k | k in 1..r where exists(j in 1..c)(puzzle[k,j] = start) },
    set of int: col_start = { k | k in 1..c where exists(j in 1..r)(puzzle[j,k] = start) },
    set of int: row_end = { k | k in 1..r where exists(j in 1..c)(puzzle[k,j] = end) },
    set of int: col_end = { k | k in 1..c where exists(j in 1..r)(puzzle[j,k] = end) }
  } in
  exists(dir_row in { -1, 0, 1 }, dir_col in { -1, 0, 1 })(
    (exists(j in max(1,row_start+dir_row)..min(r,row_start+dir_row), k in max(1,col_start+dir_col)..min(c,col_start+dir_col))(puzzle[j,k] = start+1)) /\
    (exists(j in max(1,row_end+dir_row)..min(r,row_end+dir_row), k in max(1,col_end+dir_col)..min(c,col_end+dir_col))(puzzle[j,k] = end-1))
  );

% Objective
% As this is a constraint satisfaction problem, there is no objective to minimize or maximize.
solve satisfy;
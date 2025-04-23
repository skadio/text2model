% Parameters
int: r; % Number of rows in the Laplace grid
int: c; % Number of columns in the Laplace grid
float: Z; % Zero value (constant)
float: M; % Maximum value (constant)

% Variables
array[1..r, 1..c] of var Z..M: grid; % The grid of cells, each cell has a value between Z and M
var Z..M: cell_1_1; % The value of the cell at position (1,1)

% Constraints

% Constraint 1: The value of each cell is the average of its four neighboring cells
% (top, bottom, left, and right)
constraint forall(i in 2..r-1, j in 2..c-1) (
    grid[i,j] = (grid[i-1,j] + grid[i+1,j] + grid[i,j-1] + grid[i,j+1]) / 4.0
);

% Constraint 2: The value of the cells on the top row (except the corners) is the average of its three neighboring cells
% (bottom, left, and right)
constraint forall(j in 2..c-1) (
    grid[1,j] = (grid[2,j] + grid[1,j-1] + grid[1,j+1]) / 3.0
);

% Constraint 3: The value of the cells on the bottom row (except the corners) is the average of its three neighboring cells
% (top, left, and right)
constraint forall(j in 2..c-1) (
    grid[r,j] = (grid[r-1,j] + grid[r,j-1] + grid[r,j+1]) / 3.0
);

% Constraint 4: The value of the cells on the left column (except the corners) is the average of its three neighboring cells
% (top, bottom, and right)
constraint forall(i in 2..r-1) (
    grid[i,1] = (grid[i-1,1] + grid[i+1,1] + grid[i,2]) / 3.0
);

% Constraint 5: The value of the cells on the right column (except the corners) is the average of its three neighboring cells
% (top, bottom, and left)
constraint forall(i in 2..r-1) (
    grid[i,c] = (grid[i-1,c] + grid[i+1,c] + grid[i,c-1]) / 3.0
);

% Constraint 6: The value of the top-left corner cell is the average of its two neighboring cells (bottom and right)
constraint grid[1,1] = (grid[2,1] + grid[1,2]) / 2.0;

% Constraint 7: The value of the top-right corner cell is the average of its two neighboring cells (bottom and left)
constraint grid[1,c] = (grid[2,c] + grid[1,c-1]) / 2.0;

% Constraint 8: The value of the bottom-left corner cell is the average of its two neighboring cells (top and right)
constraint grid[r,1] = (grid[r-1,1] + grid[r,2]) / 2.0;

% Constraint 9: The value of the bottom-right corner cell is the average of its two neighboring cells (top and left)
constraint grid[r,c] = (grid[r-1,c] + grid[r,c-1]) / 2.0;

% Constraint 10: The value of the cell at position (1,1) is equal to the value of the corresponding cell in the grid
constraint cell_1_1 = grid[1,1];

% Objective
solve minimize cell_1_1;
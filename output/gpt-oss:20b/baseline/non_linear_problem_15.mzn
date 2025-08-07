int: r;
int: c;
float: Z;
float: M;

array[1..r, 1..c] of var float: grid;

constraint
  forall(i in 1..r, j in 1..c) (
    grid[i,j] >= Z /\ grid[i,j] <= M
  );

constraint
  forall(i in 2..r-1, j in 2..c-1) (
    grid[i,j] = (grid[i-1,j] + grid[i+1,j] + grid[i,j-1] + grid[i,j+1]) / 4.0
  );

solve minimize grid[1,1];

output [
  "\nGrid values:\n",
  show(grid)
];
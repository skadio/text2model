int: r;
int: c;
float: Z;
float: M;

set of int: R = 1..r;
set of int: C = 1..c;

array[R, C] of var float: x;

constraint forall(i in R, j in C) (Z <= x[i,j] /\ x[i,j] <= M);

constraint forall(i in 2..r-1, j in 2..c-1) (
  4.0 * x[i,j] = x[i-1,j] + x[i+1,j] + x[i,j-1] + x[i,j+1]
);

solve minimize x[1,1];

output ["x = array2d(1..r, 1..c, [x[i,j] | i in R, j in C]);\n"];
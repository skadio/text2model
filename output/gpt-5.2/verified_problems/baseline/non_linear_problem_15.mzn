int: r;
int: c;
float: Z;
float: M;

array[1..r, 1..c] of var float: x;

constraint
  forall(i in 1..r, j in 1..c) (
    x[i,j] >= Z /\ x[i,j] <= M
  );

% Leibman five-point finite-difference approximation (interior points)
constraint
  forall(i in 2..r-1, j in 2..c-1) (
    x[i,j] = (x[i-1,j] + x[i+1,j] + x[i,j-1] + x[i,j+1]) / 4.0
  );

solve minimize x[1,1];
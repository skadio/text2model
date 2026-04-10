int: M;
int: N;

set of int: I = 1..M;
set of int: J = 1..N;

array[I, J] of float: A;
array[I] of float: B;

array[I] of float: row_norm = [ sqrt(sum(j in J)(A[i,j] * A[i,j])) | i in I ];

array[J] of var float: y;
var float: r;

constraint r >= 0.0;

constraint forall(i in I)(
  sum(j in J)(A[i,j] * y[j]) + r * row_norm[i] <= B[i]
);

solve maximize r;
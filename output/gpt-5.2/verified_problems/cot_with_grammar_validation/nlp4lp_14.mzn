int: M;
int: N;

array[1..M, 1..N] of float: A;
array[1..M] of float: B;

array[1..N] of var float: y;
var float: r;

array[1..M] of float: normA = [ sqrt(sum(j in 1..N)(A[i,j] * A[i,j])) | i in 1..M ];

constraint r >= 0.0;

constraint
  forall(i in 1..M) (
    sum(j in 1..N)(A[i,j] * y[j]) + normA[i] * r <= B[i]
  );

solve maximize r;
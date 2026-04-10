int: M;
int: N;

array[1..M, 1..N] of float: A;
array[1..M] of float: B;

set of int: I = 1..M;
set of int: J = 1..N;

array[I] of float: a_norm = [ sqrt(sum(j in J)(A[i,j] * A[i,j])) | i in I ];

var float: r;
array[J] of var float: y;

constraint r >= 0.0;

constraint
  forall(i in I) (
    sum(j in J)(A[i,j] * y[j]) + a_norm[i] * r <= B[i]
  );

solve maximize r;

output [
  "r = ", show(r), "\n",
  "y = [", concat([ if j > 1 then ", " else "" endif ++ show(y[j]) | j in J ]), "]\n"
];
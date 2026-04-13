int: M;
int: N;

array[1..M, 1..N] of float: A;
array[1..M] of float: B;

array[1..N] of var float: y;
var float: r;

constraint r >= 0.0;

constraint
  forall(i in 1..M)(
    sum(j in 1..N)(A[i,j] * y[j]) + r * sqrt(sum(j in 1..N)(A[i,j] * A[i,j])) <= B[i]
  );

solve maximize r;

output [
  "r = ", show(r), "\n",
  "y = [", concat([ if j > 1 then ", " else "" endif ++ show(y[j]) | j in 1..N ]), "]\n"
];
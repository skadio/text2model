int: M;                     % number of inequalities
int: N;                     % dimension of the space

array[1..M, 1..N] of float: A;  % coefficients of the inequalities
array[1..M] of float: B;        % right-hand side values

% Variables: y is the center of the ball, r is the radius.
array[1..N] of var float: y;
var float: r;

constraint
  forall(i in 1..M) (
    % The distance from the hyperplane a_i^T x = B[i] is given by:
    % a_i^T y + r * ||a_i|| <= B[i]
    sum(j in 1..N)( A[i,j] * y[j] ) + r * sqrt( sum(j in 1..N)( A[i,j] * A[i,j] ) ) <= B[i]
  );

solve maximize r;

output [
  "Chebyshev center (y): ", show(y), "\n",
  "Maximum radius (r): ", show(r), "\n"
];
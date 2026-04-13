% Parameters
int: M;                           % Number of inequalities
int: N;                           % Dimension of the space

array[1..M, 1..N] of float: A;    % Constraint coefficients (each row i is a_i^T)
array[1..M] of float: B;          % Right-hand side values b_i

% Precompute norms of rows of A (constants)
array[1..M] of float: Anorm =
  [ sqrt(sum(j in 1..N)(A[i,j] * A[i,j])) | i in 1..M ];

% Variables
array[1..N] of var float: y;      % Center of the inscribed ball (Chebyshev center)
var 0.0..1.0e9: r;                % Radius (bounded to avoid solver numeric limits)

% Constraints
% For each inequality a_i^T x <= b_i, require ball containment:
% a_i^T y + r * ||a_i||_2 <= b_i
constraint
  forall(i in 1..M)(
    sum(j in 1..N)(A[i,j] * y[j]) + Anorm[i] * r <= B[i]
  );

% Objective
solve maximize r;
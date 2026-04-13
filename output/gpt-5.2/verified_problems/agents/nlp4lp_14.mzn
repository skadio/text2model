% Parameters
int: M;                         % Number of inequalities
int: N;                         % Dimension of the ambient space

set of int: I = 1..M;           % Inequality index set
set of int: J = 1..N;           % Dimension index set

array[I, J] of float: A;        % Coefficients of inequalities (a_i^T x <= b_i)
array[I] of float: B;           % Right-hand side values (b_i)

% Variables
array[J] of var float: y;       % Center of the inscribed ball (Chebyshev center)
var float: r;                   % Radius of the inscribed ball (to be maximized)

% Constraints
% Radius is non-negative
constraint r >= 0.0;

% --- Chebyshev ball containment constraints ---
% For each halfspace a_i^T x <= b_i, ensure the ball (center y, radius r)
% lies entirely inside it:
%   a_i^T y + ||a_i||_2 * r <= b_i
constraint
  forall(i in I) (
    sum(j in J)(A[i, j] * y[j])
    + sqrt(sum(j in J)(A[i, j] * A[i, j])) * r
    <= B[i]
  );

% Objective
solve maximize r;
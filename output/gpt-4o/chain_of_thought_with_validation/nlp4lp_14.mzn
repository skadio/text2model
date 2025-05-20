% Parameters
int: M;                                     % Number of inequalities
int: N;                                     % Dimension of the space

array[1..M, 1..N] of float: A;              % Coefficients of the inequalities
array[1..M] of float: B;                    % Right-hand sides

array[1..M] of float: row_norm =            % Euclidean norm of each row of A
  [ sqrt(sum(j in 1..N)(A[i,j]^2)) | i in 1..M ];

% Variables
array[1..N] of var float: y;                % Coordinates of the Chebyshev center
var float: r;                               % Radius of the inscribed ball

% Constraints
constraint
    r >= 0;                                 % Non-negativity of the radius
constraint
    forall(i in 1..M) (                     % Ball must lie inside every half-space
        sum(j in 1..N)(A[i,j] * y[j]) + row_norm[i] * r <= B[i]
    );

% Objective
solve maximize r;
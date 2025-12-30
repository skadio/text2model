int: M;                          % Number of inequalities
int: N;                          % Dimension of the ambient space
array[1..M, 1..N] of float: A;  % Coefficients of the linear inequalities
array[1..M] of float: B;        % Right-hand side of the inequalities

% Variables
array[1..N] of var float: x;    % Center of the ball
var float: r;                   % Radius of the ball

% Constraints: Ensure the ball is contained within the set P
constraint forall(i in 1..M)(
    sum(j in 1..N)(A[i,j] * x[j]) <= B[i] - r
);

% Objective: Maximize the radius of the ball
solve maximize r;

% Output
output [ "Center = ", show(x), "\nRadius = ", show(r), "\n" ];
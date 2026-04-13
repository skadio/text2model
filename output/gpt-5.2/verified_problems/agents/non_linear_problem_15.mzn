% Parameters
int: r;                % Number of rows in the Laplace grid
int: c;                % Number of columns in the Laplace grid
float: Z;              % Minimum allowed cell value
float: M;              % Maximum allowed cell value

set of int: ROWS = 1..r;  % Row index set
set of int: COLS = 1..c;  % Column index set


% Variables
array[ROWS, COLS] of var float: u;  % Grid cell values (solution), bounded by Z..M

% Objective-related variable (minimize value at (1,1))
var float: u_1_1 = u[1,1];


% Constraints
% Bounds on all grid cell values
constraint forall(i in ROWS, j in COLS) (
  u[i,j] >= Z /\ u[i,j] <= M
);

% Discrete Laplace equation (Leibman five-point stencil) on interior cells:
% Each interior cell equals the average of its four orthogonal neighbors.
constraint forall(i in 2..r-1, j in 2..c-1) (
  4.0 * u[i,j] = u[i-1,j] + u[i+1,j] + u[i,j-1] + u[i,j+1]
);


% Objective
solve minimize u_1_1;
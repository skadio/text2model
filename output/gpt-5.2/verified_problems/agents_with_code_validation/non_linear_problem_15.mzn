% Parameters
int: r;                  % Number of rows in the Laplace grid
int: c;                  % Number of columns in the Laplace grid
float: Z;                % Minimum/zero bound for cell values
float: M;                % Maximum bound for cell values

set of int: ROWS = 1..r;
set of int: COLS = 1..c;

% Variables
array[ROWS, COLS] of var float: u;  % Value at each grid cell
var float: obj;                     % Objective value = u[1,1]

% Constraints

% Domain bounds for all grid values
constraint forall(i in ROWS, j in COLS) (
  Z <= u[i,j] /\ u[i,j] <= M
);

% Five-point Laplace stencil on interior points
constraint forall(i in 2..r-1, j in 2..c-1) (
  4.0 * u[i,j] = u[i-1,j] + u[i+1,j] + u[i,j-1] + u[i,j+1]
);

% Objective linkage
constraint obj = u[1,1];

solve minimize obj;
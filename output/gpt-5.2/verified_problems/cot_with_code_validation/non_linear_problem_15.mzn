% Dirichlet problem for Laplace's equation (5-point stencil)

% Parameters
int: r;
int: c;
float: Z;
float: M;

set of int: ROWS = 1..r;
set of int: COLS = 1..c;

% Variables
array[ROWS, COLS] of var float: x;

% Bounds
constraint forall(i in ROWS, j in COLS) (
  Z <= x[i,j] /\ x[i,j] <= M
);

% Interior Laplace constraints (only if there is an interior)
constraint forall(i in 2..r-1, j in 2..c-1) (
  x[i,j] = (x[i-1,j] + x[i+1,j] + x[i,j-1] + x[i,j+1]) / 4.0
);

% Objective
solve minimize x[1,1];

output [
  "x=\n"
] ++
[
  if j = 1 then "" else " " endif ++ show(x[i,j]) ++ if j = c then "\n" else "" endif
  | i in ROWS, j in COLS
];
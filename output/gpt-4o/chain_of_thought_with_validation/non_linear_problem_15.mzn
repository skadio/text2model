% Parameters
int: r;                 % Number of rows
int: c;                 % Number of columns
float: Z;               % Minimum (zero) value
float: M;               % Maximum value

set of int: Row = 1..r;
set of int: Col = 1..c;

% Optional data that might be present in the .dzn file
array[Row, Col] of float: x = array2d(Row, Col, [Z | i in Row, j in Col]);

% Variables
array[Row, Col] of var Z..M: u;

% Interior finite-difference constraints
constraint
  forall(i in 2..r-1, j in 2..c-1)(
    u[i,j] = (u[i-1,j] + u[i+1,j] + u[i,j-1] + u[i,j+1]) / 4.0
  );

% Objective
solve minimize u[1,1];
% --- Chebyshev center of a polytope ------------------------------------
% Input data (provided in a .dzn file):
%   int: M;                                 % number of inequalities
%   int: N;                                 % dimension
%   array[1..M, 1..N] of float: A;          % coefficients of inequalities
%   array[1..M]       of float: B;          % right‑hand sides

% ----- Computed constants ------------------------------------------------
array[1..M] of float: norm =
  [ sqrt( sum([ A[i,j]*A[i,j] | j in 1..N ])) | i in 1..M ];

% ----- Decision variables ------------------------------------------------
var float: r;                              % radius of the ball
array[1..N] of var float: x;               % center of the ball

% ----- Constraints -------------------------------------------------------
constraint forall(i in 1..M)(
  sum(j in 1..N)( A[i,j]*x[j] ) + r * norm[i] <= B[i]
);

% Non‑negative radius
constraint r >= 0;

% ----- Objective ----------------------------------------------------------
solve maximize r;

% ----- Output ------------------------------------------------------------
output [
  "Radius = ", show(r), "\n",
  "Center = ", show(x), "\n"
];
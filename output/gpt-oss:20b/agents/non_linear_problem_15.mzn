include "globals.mzn";

int: r;                    % number of rows
int: c;                    % number of columns
float: Z;                  % lower bound for all cells
float: M;                  % upper bound for all cells

% Grid of real variables, each between Z and M
array[1..r, 1..c] of var Z..M: u;

% Finite‑difference (five‑point) constraint for interior cells
% Only applied when the grid is large enough
constraint
  forall(i in 2..max(r-1,1), j in 2..max(c-1,1)) (
      u[i,j] * 4.0 = u[i-1,j] + u[i+1,j] + u[i,j-1] + u[i,j+1]
  );

% Objective: minimise the value at the top‑left corner
solve minimize u[1,1];

% Pretty output: show the grid row by row
output [
  "u =\n",
  concat([ 
      if j == 1 then "\n" else "" endif ++
      show(u[i,j]) ++
      if j < c then " " else "" endif
      | j in 1..c | i in 1..r
  ])
];
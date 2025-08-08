include "globals.mzn";

int: m;                      % number of marks (provided in the .dzn file)

% --------------------------------------------------------------------
%  Variables
% --------------------------------------------------------------------
array[1..m] of var 0..m*(m-1) : a;                      % positions of the marks
array[1..(m*(m-1))/2] of var 0..m*(m-1) : diffs;         % all pairwise differences

% --------------------------------------------------------------------
%  Constraints
% --------------------------------------------------------------------
constraint a[1] = 0;                      % first mark is at 0
constraint increasing(a);                 % marks are strictly increasing

% all pairwise differences
constraint diffs = [ a[j] - a[i] | i in 1..m-1, j in i+1..m ];

% each difference must be unique
constraint all_different(diffs);

% break symmetry: the first step is smaller than the last step
constraint (m > 1) -> (a[2] - a[1] < a[m] - a[m-1]);

% --------------------------------------------------------------------
%  Objective
% --------------------------------------------------------------------
solve minimize a[m];                        % minimise the length of the ruler

% --------------------------------------------------------------------
%  Output
% --------------------------------------------------------------------
output [
  "Length = ", show(a[m]), "\n",
  "Marks  = ", show(a),      "\n"
];
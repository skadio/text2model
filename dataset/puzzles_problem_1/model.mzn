include "globals.mzn"; 
% input data
int: n; % number of rows
int: m; % number of columns 
array[1..n, 1..m] of int: grid; % grid of values

% decision variables
array[1..n] of var 1..m: cols_chosen; % represents columns chosen from top to bottom
var 0..sum(grid): max_val = sum(i in 1..n) (grid[i, cols_chosen[i]]); % value to be maximized

% solve satisfy;
solve maximize max_val;

%  the movement from one row to the next can be either straight down, down to the right, or down to the left.
constraint
   forall(i in 2..n) (
     let {
       var 1..m: j
     } in
     abs(cols_chosen[i-1]-j) <=1
     /\
     cols_chosen[i] = j
   )
;

% output
output [
  "{\n",
  "  \"max_val\": " ++ show(max_val) ++ ",\n",
  "  \"cols_chosen\": " ++ show(cols_chosen) ++ ",\n",
  "  \"values\": " ++ show([grid[i,fix(cols_chosen[i])] | i in 1..n]) ++ "\n",
  "}"
];

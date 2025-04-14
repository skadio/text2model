include "globals.mzn"; 

% -----------------------------
% 1) PARAMETERS
% -----------------------------

int: num_items;  % Number of available items
int: num_bids;   % Number of bids

% Binary matrix representation of bid packages
array[1..num_bids, 1..num_items] of int: packages;
  % packages[i,j] = 1 if bid i includes item j, otherwise 0

array[1..num_bids] of int: bids;  % Value of each bid

% -----------------------------
% 2) DECISION VARIABLES
% -----------------------------

array[1..num_bids] of var 0..1: x;  % Whether bid i is selected (1) or not (0)
var int: total;  % Total value of selected bids

% -----------------------------
% 3) OBJECTIVE FUNCTION
% -----------------------------

solve :: int_search(x, first_fail, indomain_min, complete) maximize total;

% -----------------------------
% 4) CONSTRAINTS
% -----------------------------

% Compute total revenue from selected bids
constraint total = sum(i in 1..num_bids) ( x[i] * bids[i] );

% Ensure each item is assigned at most once
constraint
   forall(j in 1..num_items) (
       sum(i in 1..num_bids) (x[i] * packages[i,j]) <= 1
   );

% -----------------------------
% 5) OUTPUT
% -----------------------------

output [
  "Selected Bids: ", show(x), "\n",
  "Total Revenue: ", show(total), "\n"
];

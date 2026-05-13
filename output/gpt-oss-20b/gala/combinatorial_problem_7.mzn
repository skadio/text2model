include "globals.mzn";

/* --- Data (from the .dzn file) --- */
int: num_items;          % number of items
int: max_item;           % maximum item number (normally = num_items)
int: num_bids;           % number of bids
array[1..num_bids, 1..num_items] of int: packages;  % 1 = item is in the package, 0 otherwise
array[1..num_bids] of int: bids;                     % bid amount for each bid

/* --- Decision variables --- */
array[1..num_bids] of var bool: x;  % x[b] = 1 if bid b is selected

/* --- Constraints --- */
/* No two selected bids may share an item */
constraint
  forall(i in 1..num_items) (
    sum(b in 1..num_bids)( packages[b,i] * bool2int(x[b]) ) <= 1
  );

/* --- Objective: maximize total revenue --- */
var int: total = sum(b in 1..num_bids)( bool2int(x[b]) * bids[b] );
solve maximize total;

/* --- Output --- */
output [
  "Total revenue = ", show(total), "\n",
  "Selected bids = ", show([b | b in 1..num_bids where x[b] ]), "\n"
];
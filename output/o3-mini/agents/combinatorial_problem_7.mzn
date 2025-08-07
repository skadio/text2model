include "globals.mzn";

% Parameters (provided in the .dzn file)
int: num_items;
int: max_item;           % maximum item id, unused if items are 1..num_items
int: num_bids;
array[1..num_bids, 1..num_items] of int: packages; % packages[i,j] = 0 means bid i includes item j; 1 means not
array[1..num_bids] of int: bids;                   % bid amounts for each bid

% Decision variable: whether or not bid i is selected
array[1..num_bids] of var bool: selected;

% Compute the overall revenue of selected bids
var int: revenue = sum(i in 1..num_bids)( bool2int(selected[i]) * bids[i] );

% Conflict constraint: For each item j, at most one selected bid may include that item.
constraint 
  forall(j in 1..num_items) (
    let {
      array[1..num_bids] of var 0..1: inclusion = 
        [ bool2int(selected[i] /\ (packages[i,j] = 0)) | i in 1..num_bids ]
    } in
      count(inclusion, 1) <= 1
  );

% Solve: maximize revenue
solve maximize revenue;

% Output: Display the revenue and the selected bids vector
output [
  "Revenue = ", show(revenue), "\n",
  "Selected bids: ", show(selected), "\n"
];
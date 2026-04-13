include "globals.mzn";

% ===== Input data (from .dzn) =====
int: num_items;
int: max_item;          % not needed in the model, but provided in data
int: num_bids;

% packages[b,i] = 1 if bid b includes item i, else 0
array[1..num_bids, 1..num_items] of int: packages;

% bid value for each bid
array[1..num_bids] of int: bids;

% ===== Decision variables =====
array[1..num_bids] of var 0..1: take;     % 1 if we accept bid b

% ===== Constraints =====
% No item may be allocated to more than one accepted bid
constraint
  forall(i in 1..num_items) (
    sum(b in 1..num_bids)( take[b] * packages[b,i] ) <= 1
  );

% ===== Objective =====
var int: revenue = sum(b in 1..num_bids)( take[b] * bids[b] );
solve maximize revenue;

% ===== Output =====
output [
  "revenue = ", show(revenue), "\n",
  "take = ", show(take), "\n"
];
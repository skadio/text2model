int: num_items;
int: max_item;
int: num_bids;

array[1..num_bids, 1..num_items] of int: packages; % 0 if item is in bid's package, 1 otherwise
array[1..num_bids] of int: bids;

set of int: BIDS = 1..num_bids;
set of int: ITEMS = 1..num_items;

array[BIDS] of var bool: take;

% Each item can be allocated to at most one selected bid
constraint
  forall(i in ITEMS) (
    sum(b in BIDS) (bool2int(take[b]) * (1 - packages[b,i])) <= 1
  );

var int: revenue = sum(b in BIDS) (bids[b] * bool2int(take[b]));

solve maximize revenue;

output [
  "revenue = ", show(revenue), "\n",
  "take = ", show([bool2int(take[b]) | b in BIDS]), "\n"
];
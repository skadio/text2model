int: num_items;
int: max_item;
int: num_bids;
array[1..num_bids, 1..num_items] of int: packages;   % 0 if item j is in bid i, 1 otherwise
array[1..num_bids] of int: bids;

array[1..num_bids] of var bool: x;   % x[i] = true iff bid i is selected

constraint
  forall(j in 1..num_items) (
    sum(i in 1..num_bids where packages[i,j] == 0) (x[i]) <= 1
  );

solve maximize
  sum(i in 1..num_bids) (bool2int(x[i]) * bids[i]);

output [
  "Selected bids: ", show([i | i in 1..num_bids where x[i]]), "\n",
  "Total revenue: ", show(sum(i in 1..num_bids) (bool2int(x[i]) * bids[i])), "\n"
];
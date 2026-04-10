% Combinatorial Auction (Winner Determination)

% Parameters (must match data.dzn)
int: num_items;
int: max_item;   % not used in constraints; kept for data compatibility
int: num_bids;

array[1..num_bids, 1..num_items] of int: packages; % 0/1 matrix: 0 = item included, 1 = not included
array[1..num_bids] of int: bids;

% Decision variables
array[1..num_bids] of var 0..1: take;

% Ensure input is binary (optional but safe)
constraint forall(b in 1..num_bids, i in 1..num_items) (
  packages[b,i] in 0..1
);

% Each item can be allocated to at most one selected bid
constraint forall(i in 1..num_items) (
  sum(b in 1..num_bids)( take[b] * (1 - packages[b,i]) ) <= 1
);

% Objective: maximize total revenue
solve maximize sum(b in 1..num_bids)( bids[b] * take[b] );
% Parameters
int: num_items;                      % Number of items available in the auction
int: max_item;                       % Maximum item index/label in the auction (should equal num_items)
int: num_bids;                       % Number of bids

set of int: ITEMS = 1..num_items;    % Index set for items
set of int: BIDS  = 1..num_bids;     % Index set for bids

% packages[b,i] is 0 if item i is contained in bid b, 1 otherwise
array[BIDS, ITEMS] of int: packages; % Package incidence matrix (0/1 values as provided)
array[BIDS] of int: bids;            % Bid amount for each bid

% Variables
array[BIDS] of var 0..1: take_bid;   % 1 if bid b is selected, 0 otherwise
var int: total_revenue;              % Total revenue from selected bids

% Constraints
% Link total revenue to chosen bids
constraint
  total_revenue = sum(b in BIDS)(bids[b] * take_bid[b]);

% Non-overlapping item allocation: each item can be sold at most once
constraint
  forall(i in ITEMS) (
    sum(b in BIDS)(take_bid[b] * (1 - packages[b,i])) <= 1
  );

% Consistency check: max_item should match the item index range (if provided)
constraint
  max_item = num_items;

% Objective
solve maximize total_revenue;
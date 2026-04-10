include "globals.mzn";

% Data (embedded from problem description)
int: interactions_cart = 70;
int: refills_cart = 5;

int: interactions_hand = 85;
int: refills_hand = 20;

int: target_interactions = 4000;

float: min_cart_fraction = 0.70;
int: min_hand_servers = 3;

% Decision variables: number of servers scheduled for each delivery mode
var 0..target_interactions: nCart;
var 0..target_interactions: nHand;

% Total interactions must meet (at least) the target
constraint interactions_cart * nCart + interactions_hand * nHand >= target_interactions;

% At least 3 servers by hand
constraint nHand >= min_hand_servers;

% At least 70% of shifts are by cart:
% nCart / (nCart + nHand) >= 0.70  ==>  30*nCart >= 70*nHand
constraint (1.0 - min_cart_fraction) * int2float(nCart)
        >= min_cart_fraction * int2float(nHand);

% Objective: minimize total refills per hour
var 0..(refills_cart * target_interactions + refills_hand * target_interactions): totalRefills;
constraint totalRefills = refills_cart * nCart + refills_hand * nHand;

solve minimize totalRefills;

output [
  "nCart = ", show(nCart), "\n",
  "nHand = ", show(nHand), "\n",
  "Total interactions = ", show(interactions_cart*nCart + interactions_hand*nHand), "\n",
  "Total refills = ", show(totalRefills), "\n"
];
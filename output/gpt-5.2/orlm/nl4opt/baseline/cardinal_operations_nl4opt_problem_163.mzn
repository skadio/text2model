% Dim sum delivery scheduling: carts vs hand delivery
% Minimize total refills per hour subject to interaction target and policy constraints.

int: interactions_cart = 70;
int: refills_cart = 5;

int: interactions_hand = 85;
int: refills_hand = 20;

int: required_interactions = 4000;

float: min_cart_share = 0.70;      % at least 70% of shifts by cart
int: min_hand_servers = 3;         % at least 3 by hand

% Decision variables: number of servers (shifts) using each delivery method
var 0..1000: cart;
var 0..1000: hand;

% Total interactions must meet or exceed requirement
constraint interactions_cart * cart + interactions_hand * hand >= required_interactions;

% At least 3 hand servers
constraint hand >= min_hand_servers;

% At least 70% of shifts by cart:
% cart / (cart + hand) >= 0.70  <=>  10*cart >= 7*(cart + hand)  <=>  3*cart >= 7*hand
constraint 3 * cart >= 7 * hand;

% Objective: minimize total refills per hour
var int: total_refills = refills_cart * cart + refills_hand * hand;
solve minimize total_refills;

output [
  "cart_servers = ", show(cart), "\n",
  "hand_servers = ", show(hand), "\n",
  "total_shifts = ", show(cart + hand), "\n",
  "total_interactions = ", show(interactions_cart*cart + interactions_hand*hand), "\n",
  "total_refills = ", show(total_refills), "\n"
];
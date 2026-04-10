% Parameters
int: interactions_cart = 70;
int: refills_cart = 5;
int: interactions_hand = 85;
int: refills_hand = 20;

int: required_interactions = 4000;

float: min_cart_share = 0.70;
int: min_hand_servers = 3;

% Variables
var 0..required_interactions div interactions_cart + 100: cart_servers;
var 0..required_interactions div interactions_hand + 100: hand_servers;

var 0..1000000: total_refills;

% Constraints
constraint interactions_cart * cart_servers + interactions_hand * hand_servers >= required_interactions;

constraint hand_servers >= min_hand_servers;

constraint cart_servers + hand_servers > 0;

constraint cart_servers * 100 >= ceil(min_cart_share * 100.0) * (cart_servers + hand_servers);

constraint total_refills = refills_cart * cart_servers + refills_hand * hand_servers;

% Objective
solve minimize total_refills;
% Parameters
% Customer interactions per server per hour
int: interactions_cart = 70;
int: interactions_hand = 85;

% Refills per server per hour
int: refills_cart = 5;
int: refills_hand = 20;

% Policy / demand requirements
int: required_interactions = 4000;     % minimum total customer interactions per hour
float: min_cart_share = 0.70;          % at least 70% of delivery shifts must be by cart
int: min_hand_servers = 3;             % at least 3 servers delivering by hand

% A safe upper bound on servers (for variable bounds), derived from demand:
% In the worst case (all cart), need at most ceil(4000/70) = 58 servers.
int: max_servers = 58;

% Precompute the integer percentage threshold to avoid float-int coercion in constraints
int: min_cart_pct = ceil(min_cart_share * 100.0); % e.g., 70

% Variables
var 0..max_servers: n_cart;            % number of servers delivering by cart
var 0..max_servers: n_hand;            % number of servers delivering by hand

var 0..max_servers * refills_hand: total_refills; % total refills per hour (to minimize)

% Constraints
% Demand satisfaction: total customer interactions must meet or exceed requirement
constraint
  interactions_cart * n_cart + interactions_hand * n_hand >= required_interactions;

% Minimum staffing by hand: ensure at least the required number of hand-delivery servers
constraint
  n_hand >= min_hand_servers;

% Cart share policy: at least min_cart_share of all delivery shifts are by cart
% Integer arithmetic form:
% n_cart / (n_cart + n_hand) >= min_cart_share
% => 100*n_cart >= min_cart_pct * (n_cart + n_hand)
constraint
  100 * n_cart >= min_cart_pct * (n_cart + n_hand);

% Define total refills as the sum of refills contributed by each server type
constraint
  total_refills = refills_cart * n_cart + refills_hand * n_hand;

% Objective
solve minimize total_refills;
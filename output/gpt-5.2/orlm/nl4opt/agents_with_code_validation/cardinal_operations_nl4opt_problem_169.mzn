% Parameters
int: golf_cart_capacity = 4;           % guests per golf cart
int: pull_cart_capacity = 1;           % guests per pull cart
int: min_guests = 80;                  % minimum number of guests to transport
float: max_golf_cart_fraction = 0.60;  % at most this fraction of all carts can be golf carts (encoded via integers below)

% Variables
var 0..min_guests: num_golf_carts;     % number of golf carts used
var 0..min_guests: num_pull_carts;     % number of pull carts used
var 0..2*min_guests: total_carts;      % total number of carts used (safe upper bound)

% Constraints
% Total carts is the sum of both types
constraint total_carts = num_golf_carts + num_pull_carts;

% Must transport at least the minimum required guests
constraint
  golf_cart_capacity * num_golf_carts + pull_cart_capacity * num_pull_carts >= min_guests;

% At most 60% of all carts are golf carts:
% num_golf_carts / total_carts <= 0.60  <=>  10*num_golf_carts <= 6*total_carts
constraint
  10 * num_golf_carts <= 6 * total_carts;

% Objective
solve minimize total_carts;
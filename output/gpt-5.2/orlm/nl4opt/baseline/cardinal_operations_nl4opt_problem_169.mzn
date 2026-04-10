% Golf course carts optimization

int: guests_needed = 80;

int: cap_golf = 4;
int: cap_pull = 1;

float: max_golf_fraction = 0.60;

% Decision variables
var 0..guests_needed: golf_carts;
var 0..guests_needed: pull_carts;

var 0..2*guests_needed: total_carts = golf_carts + pull_carts;

constraint cap_golf * golf_carts + cap_pull * pull_carts >= guests_needed;

% At most 60% of carts can be golf carts:
% golf_carts <= 0.6 * (golf_carts + pull_carts)
% => 10*golf_carts <= 6*(golf_carts + pull_carts)
constraint 10 * golf_carts <= 6 * total_carts;

solve minimize total_carts;

output [
  "golf_carts=", show(golf_carts), "\n",
  "pull_carts=", show(pull_carts), "\n",
  "total_carts=", show(total_carts), "\n",
  "total_capacity=", show(cap_golf * golf_carts + cap_pull * pull_carts), "\n"
];
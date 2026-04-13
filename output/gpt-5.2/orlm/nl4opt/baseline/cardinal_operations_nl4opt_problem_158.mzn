% Aquarium show optimization: maximize total tricks given treat budget and performer mix.

int: treats_available = 200;

int: otter_tricks = 3;
int: otter_treats = 3;

int: dolphin_tricks = 1;
int: dolphin_treats = 5;

int: min_dolphins = 10;

var 0..treats_available div otter_treats: O; % number of otters
var min_dolphins..treats_available div dolphin_treats: D; % number of dolphins

constraint otter_treats * O + dolphin_treats * D <= treats_available;

% At most 30% of performers can be otters:
% O / (O + D) <= 0.3  <=>  10*O <= 3*(O + D)  <=>  7*O <= 3*D
constraint 7 * O <= 3 * D;

var int: total_tricks = otter_tricks * O + dolphin_tricks * D;

solve maximize total_tricks;

output [
  "otters=", show(O), "\n",
  "dolphins=", show(D), "\n",
  "treats_used=", show(otter_treats*O + dolphin_treats*D), "\n",
  "total_tricks=", show(total_tricks), "\n"
];
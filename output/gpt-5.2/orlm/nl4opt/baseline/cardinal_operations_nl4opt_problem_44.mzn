% Vine bottling optimization (all data embedded)

int: vine_available = 100000;   % ml
int: vintage_capacity = 500;    % ml per vintage bottle
int: regular_capacity = 750;    % ml per regular bottle

var int: v; % number of vintage bottles
var int: r; % number of regular bottles

constraint v >= 10;
constraint r >= 4 * v;

constraint vintage_capacity * v + regular_capacity * r <= vine_available;

% Maximize total number of bottles
solve maximize v + r;

output [
  "vintage_bottles=", show(v), "\n",
  "regular_bottles=", show(r), "\n",
  "total_bottles=", show(v + r), "\n",
  "vine_used_ml=", show(vintage_capacity * v + regular_capacity * r), "\n"
];
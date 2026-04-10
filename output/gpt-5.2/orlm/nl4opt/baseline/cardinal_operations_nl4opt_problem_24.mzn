% Mobile production units planning (all data embedded)

int: people_to_transport = 80;

int: cap_large = 6;
int: spots_large = 2;

int: cap_small = 2;
int: spots_small = 1;

int: min_small_units = 5;
float: min_large_fraction = 0.75;

var 0..people_to_transport: L; % number of large units
var 0..people_to_transport: S; % number of small units

constraint S >= min_small_units;

% Large units must be at least 75% of all vehicles:
% L / (L+S) >= 0.75  <=>  4L >= 3(L+S) <=> L >= 3S
constraint L >= 3 * S;

% Must transport at least the required number of people
constraint cap_large * L + cap_small * S >= people_to_transport;

var int: total_spots = spots_large * L + spots_small * S;

solve minimize total_spots;

output [
  "Large units = ", show(L), "\n",
  "Small units = ", show(S), "\n",
  "Total vehicles = ", show(L + S), "\n",
  "Total spots = ", show(total_spots), "\n",
  "Capacity = ", show(cap_large * L + cap_small * S), "\n"
];
% Recycling bins optimization (all data embedded)

int: workers_available = 100;

int: workers_small = 2;
int: workers_large = 5;

int: cap_small = 25;
int: cap_large = 60;

int: min_small = 10;
int: min_large = 4;

% Decision variables
var 0..workers_available div workers_small: small_bins;
var 0..workers_available div workers_large: large_bins;

% Constraints
constraint workers_small * small_bins + workers_large * large_bins <= workers_available;
constraint small_bins = 3 * large_bins;
constraint small_bins >= min_small;
constraint large_bins >= min_large;

% Objective: maximize total collected recycling
var int: total_recycling = cap_small * small_bins + cap_large * large_bins;
solve maximize total_recycling;

output [
  "small_bins=", show(small_bins), "\n",
  "large_bins=", show(large_bins), "\n",
  "total_recycling=", show(total_recycling), "\n"
];
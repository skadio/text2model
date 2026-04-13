% Hot dog butcher shop planning: minimize number of shops

% Data (embedded)
int: small_capacity = 30;
int: small_workers  = 2;

int: large_capacity = 70;
int: large_workers  = 4;

int: demand = 500;
int: workers_available = 30;

% Decision variables: number of each shop (nonnegative integers)
var 0..ceil(workers_available div small_workers): small_shops;
var 0..ceil(workers_available div large_workers): large_shops;

% Constraints
constraint small_capacity * small_shops + large_capacity * large_shops >= demand;
constraint small_workers * small_shops + large_workers * large_shops <= workers_available;

% Objective: minimize total number of shops
solve minimize small_shops + large_shops;

output [
  "small_shops = ", show(small_shops), "\n",
  "large_shops = ", show(large_shops), "\n",
  "total_shops = ", show(small_shops + large_shops), "\n",
  "total_hotdogs = ", show(small_capacity*small_shops + large_capacity*large_shops), "\n",
  "total_workers = ", show(small_workers*small_shops + large_workers*large_shops), "\n"
];
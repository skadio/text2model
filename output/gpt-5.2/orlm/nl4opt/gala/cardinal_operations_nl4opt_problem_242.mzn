% Hot dog butcher shop planning (minimize number of shops)
include "globals.mzn";

% Data (embedded as requested)
int: prod_small = 30;
int: workers_small = 2;

int: prod_large = 70;
int: workers_large = 4;

int: demand = 500;
int: workers_avail = 30;

% Decision variables: number of shops of each type
var 0..(workers_avail div workers_small): small;
var 0..(workers_avail div workers_large): large;

% Constraints
constraint prod_small * small + prod_large * large >= demand;
constraint workers_small * small + workers_large * large <= workers_avail;

% Objective: minimize total number of shops
var 0..(workers_avail div workers_small) + (workers_avail div workers_large): total_shops;
constraint total_shops = small + large;

solve minimize total_shops;

output [
  "small = ", show(small), "\n",
  "large = ", show(large), "\n",
  "total_shops = ", show(total_shops), "\n",
  "hotdogs = ", show(prod_small * small + prod_large * large), "\n",
  "workers_used = ", show(workers_small * small + workers_large * large), "\n"
];
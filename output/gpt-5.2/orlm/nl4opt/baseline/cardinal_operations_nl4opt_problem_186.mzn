% Mine wagons optimization (all data embedded)

int: small_capacity = 20;
int: large_capacity = 50;
int: ore_required  = 2000;

int: min_large = 10;

% Decision variables: number of wagons
var 0..ore_required div small_capacity: small;
var min_large..ore_required div large_capacity: large;

constraint small_capacity * small + large_capacity * large >= ore_required;
constraint small >= 2 * large;

var int: total_wagons = small + large;
solve minimize total_wagons;

output [
  "small = ", show(small), "\n",
  "large = ", show(large), "\n",
  "total_wagons = ", show(total_wagons), "\n",
  "ore_moved = ", show(small_capacity*small + large_capacity*large), "\n"
];
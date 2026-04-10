int: people_available = 100;

int: cap_small = 20;
int: cap_large = 50;

int: people_small = 1;
int: people_large = 3;

int: min_small = 5;
int: min_large = 3;

var int: small >= min_small;
var int: large >= min_large;

constraint small = 3 * large;
constraint people_small * small + people_large * large <= people_available;

var int: total_sand = cap_small * small + cap_large * large;

solve maximize total_sand;

output [
  "small_containers=", show(small), "\n",
  "large_containers=", show(large), "\n",
  "people_used=", show(people_small * small + people_large * large), "\n",
  "total_sand=", show(total_sand), "\n"
];
int: people_available = 30;

int: people_small = 2;
int: people_large = 4;

int: cap_small = 30;
int: cap_large = 50;

int: min_small = 10;
int: min_large = 3;

var 0..100: small;
var 0..100: large;

constraint people_small * small + people_large * large <= people_available;

constraint small >= min_small;
constraint large >= min_large;

constraint small = 2 * large;

var int: total_snow = cap_small * small + cap_large * large;

solve maximize total_snow;

output [
  "small_trucks = ", show(small), "\n",
  "large_trucks = ", show(large), "\n",
  "total_snow = ", show(total_snow), "\n"
];
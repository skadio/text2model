% Honey transport optimization: choose number of small and large bottles

int: cap_small = 5;
int: cap_large = 20;

int: max_small_avail = 300;
int: max_large_avail = 100;

int: max_total_bottles = 200;
int: min_large_required = 50;

var 0..max_small_avail: small;
var 0..max_large_avail: large;

constraint small + large <= max_total_bottles;
constraint large >= min_large_required;
constraint small >= 2 * large;

var int: total_honey = cap_small * small + cap_large * large;

solve maximize total_honey;

output [
  "small=", show(small), "\n",
  "large=", show(large), "\n",
  "total_bottles=", show(small + large), "\n",
  "total_honey=", show(total_honey), "\n"
];
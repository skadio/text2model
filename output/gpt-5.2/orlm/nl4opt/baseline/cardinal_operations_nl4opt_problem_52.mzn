% Snack exporter suitcase optimization (all data embedded)

int: cap_small = 50;
int: cap_large = 80;

int: max_small = 70;
int: max_large = 50;

int: min_large = 15;
int: max_total = 70;

var 0..max_small: small;
var 0..max_large: large;

constraint large >= min_large;
constraint small >= 2 * large;
constraint small + large <= max_total;

var int: total_snacks = cap_small * small + cap_large * large;

solve maximize total_snacks;

output [
  "small=", show(small), "\n",
  "large=", show(large), "\n",
  "total_suitcases=", show(small + large), "\n",
  "total_snacks=", show(total_snacks), "\n"
];
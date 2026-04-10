% Parameters (with values embedded)
int: small_capacity = 5;
int: large_capacity = 20;

int: max_small_available = 300;
int: max_large_available = 100;

int: max_total_bottles = 200;
int: min_large_used = 50;

% Variables
var 0..max_small_available: small_used;
var 0..max_large_available: large_used;

% Constraints
constraint small_used <= max_small_available;
constraint large_used <= max_large_available;

constraint small_used + large_used <= max_total_bottles;
constraint large_used >= min_large_used;

% At least twice as many small bottles as large bottles
constraint small_used >= 2 * large_used;

% Objective
var int: total_honey = small_capacity * small_used + large_capacity * large_used;

solve maximize total_honey;

output [
  "small_used = ", show(small_used), "\n",
  "large_used = ", show(large_used), "\n",
  "total_bottles = ", show(small_used + large_used), "\n",
  "total_honey = ", show(total_honey), "\n"
];
% Water bottle production optimization

int: water_available = 250000; % ml

int: glass_capacity = 500;     % ml per glass bottle
int: plastic_capacity = 750;   % ml per plastic bottle

var 20..water_available div glass_capacity: g; % number of glass bottles (at least 20)
var 0..water_available div plastic_capacity: p; % number of plastic bottles

constraint glass_capacity * g + plastic_capacity * p <= water_available;
constraint p >= 3 * g;

var int: total_bottles = g + p;

solve maximize total_bottles;

output [
  "glass_bottles = ", show(g), "\n",
  "plastic_bottles = ", show(p), "\n",
  "total_bottles = ", show(total_bottles), "\n",
  "water_used_ml = ", show(glass_capacity * g + plastic_capacity * p), "\n"
];
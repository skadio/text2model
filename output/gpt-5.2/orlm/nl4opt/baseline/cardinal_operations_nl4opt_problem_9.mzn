int: water_avail = 500;
int: pill_avail  = 700;

int: water_small = 10;
int: pill_small  = 15;
int: paste_small = 20;

int: water_large = 20;
int: pill_large  = 20;
int: paste_large = 30;

var 0..water_avail div water_small: x_small;
var 0..water_avail div water_large: x_large;

constraint water_small * x_small + water_large * x_large <= water_avail;
constraint pill_small  * x_small + pill_large  * x_large <= pill_avail;

var int: total_paste = paste_small * x_small + paste_large * x_large;

solve maximize total_paste;

output [
  "small_containers = ", show(x_small), "\n",
  "large_containers = ", show(x_large), "\n",
  "total_paste = ", show(total_paste), "\n",
  "water_used = ", show(water_small * x_small + water_large * x_large), "\n",
  "pill_used = ", show(pill_small * x_small + pill_large * x_large), "\n"
];
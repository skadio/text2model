% Honey jar filling optimization

int: honey_ml = 20000;
int: glass_capacity = 250;
int: plastic_capacity = 300;

var 0..honey_ml div glass_capacity: g; % number of glass jars
var 0..honey_ml div plastic_capacity: p; % number of plastic jars

constraint g >= 20;
constraint p >= 2 * g;

constraint glass_capacity * g + plastic_capacity * p <= honey_ml;

solve maximize g + p;

output [
  "glass_jars = ", show(g), "\n",
  "plastic_jars = ", show(p), "\n",
  "total_jars = ", show(g + p), "\n",
  "used_honey_ml = ", show(glass_capacity * g + plastic_capacity * p), "\n",
  "unused_honey_ml = ", show(honey_ml - (glass_capacity * g + plastic_capacity * p)), "\n"
];
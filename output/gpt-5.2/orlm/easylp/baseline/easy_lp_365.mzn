int: max_wheat_corn = 50;
int: max_rice_soy = 30;
int: min_wheat_rice = 20;
int: min_corn_soy = 15;

int: cost_wheat = 4;
int: cost_corn = 3;
int: cost_rice = 2;
int: cost_soy = 1;

var 0..max_wheat_corn: wheat;
var 0..max_wheat_corn: corn;
var 0..max_rice_soy: rice;
var 0..max_rice_soy: soybean;

constraint wheat + corn <= max_wheat_corn;
constraint rice + soybean <= max_rice_soy;

constraint wheat + rice >= min_wheat_rice;
constraint corn + soybean >= min_corn_soy;

var int: total_cost = cost_wheat*wheat + cost_corn*corn + cost_rice*rice + cost_soy*soybean;

solve minimize total_cost;

output [
  "wheat=", show(wheat), "\n",
  "corn=", show(corn), "\n",
  "rice=", show(rice), "\n",
  "soybean=", show(soybean), "\n",
  "total_cost=", show(total_cost), "\n"
];
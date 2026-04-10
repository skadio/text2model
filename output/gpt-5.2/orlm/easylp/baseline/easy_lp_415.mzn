% Marketing budget distribution: TV and Radio (integer ad slots)

var 0..1000: tv;
var 0..1000: radio;

constraint tv + radio >= 300;
constraint tv + radio <= 1000;
constraint tv - radio >= 100;

var int: total_cost = 200 * tv + 500 * radio;

solve minimize total_cost;

output [
  "tv_units = ", show(tv), "\n",
  "radio_units = ", show(radio), "\n",
  "total_units = ", show(tv + radio), "\n",
  "total_cost_dollars = ", show(total_cost), "\n"
];
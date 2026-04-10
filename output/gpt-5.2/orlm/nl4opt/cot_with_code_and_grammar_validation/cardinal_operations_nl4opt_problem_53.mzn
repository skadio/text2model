float: cost_C = 2.0;
float: cost_Y = 3.0;

float: nit_C = 1.5;
float: vit_C = 3.0;

float: nit_Y = 5.0;
float: vit_Y = 1.0;

float: req_nit = 5.0;
float: req_vit = 8.0;

var 0.0..1.0e9: xC;
var 0.0..1.0e9: xY;

constraint nit_C * xC + nit_Y * xY >= req_nit;
constraint vit_C * xC + vit_Y * xY >= req_vit;

var float: total_cost;
constraint total_cost = cost_C * xC + cost_Y * xY;

solve minimize total_cost;

output [
  "xC = ", show(xC), " kg\n",
  "xY = ", show(xY), " kg\n",
  "total_cost = $", show(total_cost), "\n"
];
float: min_protein = 30.0;
float: min_fat = 50.0;

float: cost_A = 100.0;
float: protein_A = 10.0;
float: fat_A = 8.0;

float: cost_B = 80.0;
float: protein_B = 7.0;
float: fat_B = 15.0;

var 0.0..1.0e9: xA;
var 0.0..1.0e9: xB;

constraint protein_A * xA + protein_B * xB >= min_protein;
constraint fat_A * xA + fat_B * xB >= min_fat;

var float: total_cost = cost_A * xA + cost_B * xB;

solve minimize total_cost;

output [
  "xA = ", show(xA), " kg\n",
  "xB = ", show(xB), " kg\n",
  "total_cost = ", show(total_cost), "\n"
];
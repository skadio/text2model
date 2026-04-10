int: min_protein = 30;
int: min_fat = 50;

int: cost_A = 100;
int: prot_A = 10;
int: fat_A = 8;

int: cost_B = 80;
int: prot_B = 7;
int: fat_B = 15;

var float: xA;
var float: xB;

constraint xA >= 0.0;
constraint xB >= 0.0;

constraint prot_A * xA + prot_B * xB >= min_protein;
constraint fat_A * xA + fat_B * xB >= min_fat;

var float: total_cost = cost_A * xA + cost_B * xB;

solve minimize total_cost;

output
[
  "xA = ", show(xA), "\n",
  "xB = ", show(xB), "\n",
  "total_cost = ", show(total_cost), "\n"
];
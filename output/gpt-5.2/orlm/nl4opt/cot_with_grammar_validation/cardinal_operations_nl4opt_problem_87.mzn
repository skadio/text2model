par float: cost_noodles = 5.0;
par float: cost_bar = 2.5;

par float: cal_noodles = 600.0;
par float: cal_bar = 250.0;

par float: prot_noodles = 1.5;
par float: prot_bar = 5.0;

par float: min_calories = 2000.0;
par float: min_protein = 16.0;

var float: x_noodles;
var float: x_bar;

constraint x_noodles >= 0.0;
constraint x_bar >= 0.0;

constraint cal_noodles * x_noodles + cal_bar * x_bar >= min_calories;
constraint prot_noodles * x_noodles + prot_bar * x_bar >= min_protein;

solve minimize cost_noodles * x_noodles + cost_bar * x_bar;

output [
  "x_noodles = ", show(x_noodles), "\n",
  "x_bar = ", show(x_bar), "\n",
  "min_cost = ", show(cost_noodles * x_noodles + cost_bar * x_bar), "\n"
];
float: cost_noodles = 5.0;
float: cost_bar = 2.5;

float: cal_noodles = 600.0;
float: cal_bar = 250.0;

float: prot_noodles = 1.5;
float: prot_bar = 5.0;

float: min_cal = 2000.0;
float: min_prot = 16.0;

var float: noodles;
var float: protein_bar;

constraint noodles >= 0.0;
constraint protein_bar >= 0.0;

constraint cal_noodles * noodles + cal_bar * protein_bar >= min_cal;
constraint prot_noodles * noodles + prot_bar * protein_bar >= min_prot;

solve minimize cost_noodles * noodles + cost_bar * protein_bar;

output [
  "noodles = ", show(noodles), "\n",
  "protein_bar = ", show(protein_bar), "\n",
  "total_cost = ", show(cost_noodles * noodles + cost_bar * protein_bar), "\n"
];
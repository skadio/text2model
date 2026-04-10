% Super Shop snack mix optimization (LP)

% Mix composition (fractions)
float: pct_catpaw_mix1 = 0.20;
float: pct_goldshark_mix1 = 0.80;
float: pct_catpaw_mix2 = 0.35;
float: pct_goldshark_mix2 = 0.65;

% Available raw materials (kg)
float: avail_catpaw = 20.0;
float: avail_goldshark = 50.0;

% Profit per kg of each mix ($/kg)
float: profit_mix1 = 12.0;
float: profit_mix2 = 15.0;

% Decision variables (kg produced)
var float: kg_mix1;
var float: kg_mix2;

% Nonnegativity
constraint kg_mix1 >= 0.0;
constraint kg_mix2 >= 0.0;

% Resource constraints
constraint pct_catpaw_mix1 * kg_mix1 + pct_catpaw_mix2 * kg_mix2 <= avail_catpaw;
constraint pct_goldshark_mix1 * kg_mix1 + pct_goldshark_mix2 * kg_mix2 <= avail_goldshark;

% Objective: maximize profit
solve maximize profit_mix1 * kg_mix1 + profit_mix2 * kg_mix2;

output [
  "kg_mix1 = ", show(kg_mix1), "\n",
  "kg_mix2 = ", show(kg_mix2), "\n",
  "profit  = ", show(profit_mix1 * kg_mix1 + profit_mix2 * kg_mix2), "\n"
];
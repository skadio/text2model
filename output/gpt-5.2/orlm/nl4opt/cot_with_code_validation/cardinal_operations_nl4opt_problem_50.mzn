% Super Shop snack mixes (LP)
% Data (embedded)
float: cat_available = 20.0;
float: shark_available = 50.0;

float: cat_frac_mix1 = 0.20;
float: shark_frac_mix1 = 0.80;

float: cat_frac_mix2 = 0.35;
float: shark_frac_mix2 = 0.65;

float: profit_mix1 = 12.0;
float: profit_mix2 = 15.0;

% Variables: kg of each mix to produce
var float: x1; % mix 1
var float: x2; % mix 2

% Nonnegativity
constraint x1 >= 0.0;
constraint x2 >= 0.0;

% Resource constraints
constraint cat_frac_mix1 * x1 + cat_frac_mix2 * x2 <= cat_available;
constraint shark_frac_mix1 * x1 + shark_frac_mix2 * x2 <= shark_available;

% Objective: maximize profit
solve maximize profit_mix1 * x1 + profit_mix2 * x2;

output [
  "x1 (kg mix1) = ", show(x1), "\n",
  "x2 (kg mix2) = ", show(x2), "\n",
  "profit = ", show(profit_mix1 * x1 + profit_mix2 * x2), "\n"
];
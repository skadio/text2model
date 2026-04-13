% Snack mix profit maximization (linear programming)

% Data (embedded from problem statement)
float: cat_available = 20.0;     % kg
float: shark_available = 50.0;   % kg

float: cat_frac_mix1 = 0.20;
float: shark_frac_mix1 = 0.80;
float: cat_frac_mix2 = 0.35;
float: shark_frac_mix2 = 0.65;

float: profit_mix1 = 12.0;       % $/kg
float: profit_mix2 = 15.0;       % $/kg

% Decision variables: kg of each mix to produce
var float: x1 >= 0.0;   % kg of mix 1
var float: x2 >= 0.0;   % kg of mix 2

% Resource constraints
constraint cat_frac_mix1 * x1 + cat_frac_mix2 * x2 <= cat_available;
constraint shark_frac_mix1 * x1 + shark_frac_mix2 * x2 <= shark_available;

% Objective: maximize profit
var float: total_profit = profit_mix1 * x1 + profit_mix2 * x2;
solve maximize total_profit;

output [
  "Mix1_kg = ", show(x1), "\n",
  "Mix2_kg = ", show(x2), "\n",
  "Total_profit = ", show(total_profit), "\n"
];
% Marketing campaign optimization (all data embedded)

int: min_effectiveness = 100;

% Effectiveness coefficients (impact points per dollar)
int: eff_adv = 4;
int: eff_pro = 5;

% Balance constraint: advertising cannot exceed promotion by more than $50
int: max_adv_over_pro = 50;

% Decision variables (integer dollars)
var 0..100000: adv;
var 0..100000: pro;

% Constraints
constraint eff_adv * adv + eff_pro * pro >= min_effectiveness;
constraint adv - pro <= max_adv_over_pro;

% Objective: minimize total spend
var 0..200000: total_spend = adv + pro;
solve minimize total_spend;

% Output (already integer dollars, so "rounded to nearest dollar" is itself)
output [
  "Advertising: $", show(adv), "\n",
  "Promotion: $", show(pro), "\n",
  "Total spend (rounded): $", show(total_spend), "\n",
  "Effectiveness: ", show(eff_adv * adv + eff_pro * pro), " impact points\n"
];
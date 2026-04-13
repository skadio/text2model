% Parameters
int: min_effectiveness = 100;
int: eff_adv_coeff = 2;
int: eff_pro_coeff = 3;

int: impact_adv_per_dollar = 4;
int: impact_pro_per_dollar = 5;

int: max_adv_excess_over_pro = 50;

% Variables
var 0..1000: adv;
var 0..1000: pro;
var 0..2000: total_spend;

% Constraints
constraint eff_adv_coeff * adv + eff_pro_coeff * pro >= min_effectiveness;
constraint adv - pro <= max_adv_excess_over_pro;

constraint total_spend = adv + pro;

% Objective
solve minimize total_spend;
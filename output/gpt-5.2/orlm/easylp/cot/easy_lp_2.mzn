% Parameters (with values embedded)
int: min_effectiveness = 100;
int: adv_weight = 2;
int: prom_weight = 3;
int: max_adv_over_prom = 50;

% (Impact points per $1 spent; not needed for feasibility since objective is total spend,
% but included as given data.)
int: adv_impact_per_dollar = 4;
int: prom_impact_per_dollar = 5;

% Variable bounds (sufficiently large upper bounds)
int: UB = 10000;

% Variables
var 0..UB: Advertising;
var 0..UB: Promotion;
var 0..2*UB+3*UB: effectiveness;
var 0..2*UB: total_spend;

% Constraints
constraint effectiveness = adv_weight * Advertising + prom_weight * Promotion;
constraint effectiveness >= min_effectiveness;

constraint Advertising - Promotion <= max_adv_over_prom;

constraint total_spend = Advertising + Promotion;

% Objective
solve minimize total_spend;
% Parameters
int: min_effectiveness = 50;
int: max_fatigue = 300;

int: eff_coeff_ad1 = 1;
int: eff_coeff_ad2 = 1;

int: fatigue_coeff_ad1 = 4;
int: fatigue_coeff_ad2 = 6;

int: cost_ad1 = 5;
int: cost_ad2 = 3;

% Variables
var 0..max_fatigue div fatigue_coeff_ad1: Ad1;
var 0..max_fatigue div fatigue_coeff_ad2: Ad2;

var 0..cost_ad1*(max_fatigue div fatigue_coeff_ad1) + cost_ad2*(max_fatigue div fatigue_coeff_ad2): total_cost;

% Constraints
constraint eff_coeff_ad1 * Ad1 + eff_coeff_ad2 * Ad2 >= min_effectiveness;

constraint fatigue_coeff_ad1 * Ad1 + fatigue_coeff_ad2 * Ad2 <= max_fatigue;

constraint total_cost = cost_ad1 * Ad1 + cost_ad2 * Ad2;

% Objective
solve minimize total_cost;
% Parameters (with values embedded)
int: min_effectiveness = 50;
int: max_fatigue = 300;

int: eff_per_dollar_ad1 = 1;
int: eff_per_dollar_ad2 = 1;

int: fatigue_coeff_ad1 = 4;
int: fatigue_coeff_ad2 = 6;

int: cost_ad1 = 5;
int: cost_ad2 = 3;

% Variables
var 0..300: Ad1;  % integer dollars allocated to Ad1
var 0..300: Ad2;  % integer dollars allocated to Ad2
var 0..(cost_ad1*300 + cost_ad2*300): TotalCost;

% Constraints
constraint Ad1 + Ad2 >= min_effectiveness;
constraint fatigue_coeff_ad1 * Ad1 + fatigue_coeff_ad2 * Ad2 <= max_fatigue;

constraint TotalCost = cost_ad1 * Ad1 + cost_ad2 * Ad2;

% Objective
solve minimize TotalCost;
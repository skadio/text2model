% Parameters
int: min_total = 300;
int: max_electricity = 2000;

int: elec_led = 5;
int: elec_fluor = 8;

int: changes_led = 3;
int: changes_fluor = 4;

/* At least 30% fluorescence:
   fluor >= 0.30 * (led + fluor)  ->  10*fluor >= 3*(led+fluor) -> 7*fluor >= 3*led
*/
int: fluor_ratio_num = 7;
int: fluor_ratio_den = 3;

% Variables
int: ub_led = max_electricity div elec_led;
int: ub_fluor = max_electricity div elec_fluor;

var 0..ub_led: led;
var 0..ub_fluor: fluor;

% Constraints
constraint led + fluor >= min_total;

constraint elec_led * led + elec_fluor * fluor <= max_electricity;

constraint fluor_ratio_num * fluor >= fluor_ratio_den * led;

% Objective
solve minimize changes_led * led + changes_fluor * fluor;
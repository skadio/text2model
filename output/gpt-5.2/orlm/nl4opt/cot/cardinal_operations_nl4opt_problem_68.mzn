% Parameters (with values embedded)
int: allergy_rate_f1 = 20;
int: fever_rate_f1   = 15;
int: allergy_rate_f2 = 10;
int: fever_rate_f2   = 30;

int: compound_per_hour_f1 = 20;
int: compound_per_hour_f2 = 30;
int: compound_available   = 1000;

int: min_allergy = 700;
int: min_fever   = 600;

% Upper bounds derived from compound availability (cannot exceed even if other constraints allow)
int: max_h1 = compound_available div compound_per_hour_f1; % 50
int: max_h2 = compound_available div compound_per_hour_f2; % 33

% Variables
var 0..max_h1: h1;  % hours to run factory 1
var 0..max_h2: h2;  % hours to run factory 2

% Constraints
constraint allergy_rate_f1 * h1 + allergy_rate_f2 * h2 >= min_allergy;
constraint fever_rate_f1   * h1 + fever_rate_f2   * h2 >= min_fever;

constraint compound_per_hour_f1 * h1 + compound_per_hour_f2 * h2 <= compound_available;

% Objective
solve minimize h1 + h2;
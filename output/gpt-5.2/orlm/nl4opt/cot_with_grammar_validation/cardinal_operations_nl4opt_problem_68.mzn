% Parameters
int: allergy_per_hr_f1 = 20;
int: fever_per_hr_f1   = 15;
int: compound_per_hr_f1 = 20;

int: allergy_per_hr_f2 = 10;
int: fever_per_hr_f2   = 30;
int: compound_per_hr_f2 = 30;

int: compound_available = 1000;

int: allergy_required = 700;
int: fever_required   = 600;

% Upper bounds from compound availability (nonnegative hours)
int: max_h1 = compound_available div compound_per_hr_f1; % 50
int: max_h2 = compound_available div compound_per_hr_f2; % 33

% Variables
var 0..max_h1: h1;
var 0..max_h2: h2;
var 0..(max_h1 + max_h2): total_time;

% Constraints
constraint total_time = h1 + h2;

constraint allergy_per_hr_f1 * h1 + allergy_per_hr_f2 * h2 >= allergy_required;
constraint fever_per_hr_f1   * h1 + fever_per_hr_f2   * h2 >= fever_required;

constraint compound_per_hr_f1 * h1 + compound_per_hr_f2 * h2 <= compound_available;

% Objective
solve minimize total_time;
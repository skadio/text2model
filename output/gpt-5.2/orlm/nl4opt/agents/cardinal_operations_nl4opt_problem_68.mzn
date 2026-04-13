% Parameters
% Production rates (pills per hour)
int: allergy_rate_f1 = 20;
int: fever_rate_f1   = 15;
int: allergy_rate_f2 = 10;
int: fever_rate_f2   = 30;

% Rare compound usage (units per hour)
int: compound_use_f1 = 20;
int: compound_use_f2 = 30;

% Available rare compound (units)
int: compound_available = 1000;

% Minimum required production (pills)
int: min_allergy = 700;
int: min_fever   = 600;

% Upper bounds on hours derived from rare compound availability (for bounded variables)
int: max_hours_f1 = compound_available div compound_use_f1; % 50
int: max_hours_f2 = compound_available div compound_use_f2; % 33


% Variables
% Hours to run each factory (nonnegative, bounded by compound feasibility)
var 0..max_hours_f1: hours_f1; % hours for factory 1
var 0..max_hours_f2: hours_f2; % hours for factory 2

% Total pills produced (bounded by max hours and rates)
var 0..(allergy_rate_f1 * max_hours_f1 + allergy_rate_f2 * max_hours_f2): total_allergy;
var 0..(fever_rate_f1   * max_hours_f1 + fever_rate_f2   * max_hours_f2): total_fever;

% Total rare compound used (bounded by availability)
var 0..compound_available: total_compound_used;

% Total time objective (total hours run across both factories)
var 0..(max_hours_f1 + max_hours_f2): total_hours;


% Constraints
% Link total production variables to hours run in each factory
constraint
  total_allergy =
    allergy_rate_f1 * hours_f1 + allergy_rate_f2 * hours_f2;

constraint
  total_fever =
    fever_rate_f1 * hours_f1 + fever_rate_f2 * hours_f2;

% Enforce minimum required production levels
constraint total_allergy >= min_allergy;
constraint total_fever   >= min_fever;

% Link total rare compound usage to hours and enforce availability
constraint
  total_compound_used =
    compound_use_f1 * hours_f1 + compound_use_f2 * hours_f2;

constraint total_compound_used <= compound_available;

% Link total hours variable to factory hours (objective variable)
constraint total_hours = hours_f1 + hours_f2;


% Objective
solve minimize total_hours;
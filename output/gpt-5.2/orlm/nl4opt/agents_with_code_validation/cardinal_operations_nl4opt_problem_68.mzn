% Parameters
% Production rates (pills per hour)
int: allergy_per_hour_f1 = 20;
int: fever_per_hour_f1   = 15;
int: allergy_per_hour_f2 = 10;
int: fever_per_hour_f2   = 30;

% Rare compound usage (units per hour)
int: rare_per_hour_f1 = 20;
int: rare_per_hour_f2 = 30;

% Resource availability and minimum demand
int: rare_available = 1000;
int: min_allergy    = 700;
int: min_fever      = 600;

% Derived (safe) upper bounds on hours from rare compound limit
int: max_hours_f1 = rare_available div rare_per_hour_f1; % 50
int: max_hours_f2 = rare_available div rare_per_hour_f2; % 33


% Variables
% Hours to run each factory (integer hours, bounded by rare-compound feasibility)
var 0..max_hours_f1: hours_f1;
var 0..max_hours_f2: hours_f2;

% Total production (bounded integer variables for use in constraints/objective)
var 0..(allergy_per_hour_f1*max_hours_f1 + allergy_per_hour_f2*max_hours_f2): total_allergy;
var 0..(fever_per_hour_f1*max_hours_f1   + fever_per_hour_f2*max_hours_f2):   total_fever;

% Total rare compound used (bounded)
var 0..rare_available: total_rare_used;

% Total time (objective)
var 0..(max_hours_f1 + max_hours_f2): total_time;


% Constraints
% Link totals to decision variables
constraint total_allergy   = allergy_per_hour_f1*hours_f1 + allergy_per_hour_f2*hours_f2;
constraint total_fever     = fever_per_hour_f1*hours_f1   + fever_per_hour_f2*hours_f2;
constraint total_rare_used = rare_per_hour_f1*hours_f1    + rare_per_hour_f2*hours_f2;
constraint total_time      = hours_f1 + hours_f2;

% Demand satisfaction constraints (meet minimum required production)
constraint total_allergy >= min_allergy;
constraint total_fever   >= min_fever;

% Rare compound capacity constraint (do not exceed available compound)
constraint total_rare_used <= rare_available;


% Objective
solve minimize total_time;
% Parameters
% Medicine delivered per serving (units)
float: throat_meds_s1 = 0.5;   % syrup 1 -> throat
float: lungs_meds_s1  = 0.4;   % syrup 1 -> lungs
float: throat_meds_s2 = 0.2;   % syrup 2 -> throat
float: lungs_meds_s2  = 0.5;   % syrup 2 -> lungs

% Sugar per serving (units)
float: sugar_s1 = 0.5;         % syrup 1 sugar
float: sugar_s2 = 0.3;         % syrup 2 sugar

% Requirements (units)
float: throat_max = 5.0;       % at most this much throat medicine
float: lungs_min  = 4.0;       % at least this much lungs medicine

% Variables
var 0.0..1000.0: servings_s1;        % number of servings of syrup 1 (non-negative)
var 0.0..1000.0: servings_s2;        % number of servings of syrup 2 (non-negative)

var 0.0..1000.0: total_throat_meds;  % total medicine to throat
var 0.0..1000.0: total_lungs_meds;   % total medicine to lungs
var 0.0..1000.0: total_sugar;        % total sugar intake

% Constraints
% --- Link totals to decision variables (linear definitions) ---
constraint
  total_throat_meds =
    throat_meds_s1 * servings_s1 + throat_meds_s2 * servings_s2;

constraint
  total_lungs_meds =
    lungs_meds_s1 * servings_s1 + lungs_meds_s2 * servings_s2;

constraint
  total_sugar =
    sugar_s1 * servings_s1 + sugar_s2 * servings_s2;

% --- Medical requirement constraints ---
% Throat medicine: at most the allowed maximum
constraint
  total_throat_meds <= throat_max;

% Lungs medicine: at least the required minimum
constraint
  total_lungs_meds >= lungs_min;

% Objective
solve minimize total_sugar;
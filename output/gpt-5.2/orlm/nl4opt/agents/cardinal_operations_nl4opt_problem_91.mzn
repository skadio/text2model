% Parameters
% Nutrition per meal (embedded from problem description)
int: protein_turkey = 20;
int: carbs_turkey   = 30;
int: fat_turkey     = 12;

int: protein_tuna = 18;
int: carbs_tuna   = 25;
int: fat_tuna     = 8;

% Minimum required totals
int: min_protein = 150;
int: min_carbs   = 200;

% Turkey share limit: turkey <= 40% of all meals
% Use exact rational 2/5 to avoid floating point
int: turkey_share_num = 2;
int: turkey_share_den = 5;

% Variables
% Number of each meal (nonnegative integers)
var 0..1000: n_turkey; % turkey dinners eaten
var 0..1000: n_tuna;   % tuna salad sandwiches eaten

% Total fat intake (to be minimized)
var 0..(fat_turkey*1000 + fat_tuna*1000): total_fat;

% Constraints
% Link total fat variable to meal counts
constraint
  total_fat = fat_turkey * n_turkey + fat_tuna * n_tuna;

% Meet minimum protein requirement
constraint
  protein_turkey * n_turkey + protein_tuna * n_tuna >= min_protein;

% Meet minimum carbs requirement
constraint
  carbs_turkey * n_turkey + carbs_tuna * n_tuna >= min_carbs;

% Turkey share constraint: n_turkey <= 0.4 * (n_turkey + n_tuna)
% Enforced with integer arithmetic: den * n_turkey <= num * (n_turkey + n_tuna)
constraint
  turkey_share_den * n_turkey <= turkey_share_num * (n_turkey + n_tuna);

% Objective
solve minimize total_fat;
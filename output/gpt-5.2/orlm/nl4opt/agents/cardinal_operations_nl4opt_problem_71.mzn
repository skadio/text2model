% Parameters
int: imported_available = 300;            % Total available imported material units
int: mrna_available = 400;                % Total available mRNA units

int: imported_per_dose_A = 30;            % Imported material units per dose of medicine A
int: mrna_per_dose_A = 50;                % mRNA units per dose of medicine A

int: imported_per_dose_B = 40;            % Imported material units per dose of medicine B
int: mrna_per_dose_B = 30;                % mRNA units per dose of medicine B

int: max_doses_A = 5;                     % Upper bound on doses of medicine A

int: people_treated_per_dose_A = 12;      % People treated per dose of medicine A
int: people_treated_per_dose_B = 8;       % People treated per dose of medicine B

% Variables
var 0..max_doses_A: doses_A;              % Number of doses of medicine A to produce

% Upper bound for B based on the tightest single-resource bound (ignoring A)
var 0..min(imported_available div imported_per_dose_B,
           mrna_available div mrna_per_dose_B): doses_B;  % Number of doses of medicine B to produce

% Total treated people (bounded safely using maximum possible A and B)
var 0..(people_treated_per_dose_A * max_doses_A
       + people_treated_per_dose_B * (mrna_available div mrna_per_dose_B)): total_people_treated;

% Constraints

% --- Resource capacity constraints (imported material and mRNA) ---
constraint
  imported_per_dose_A * doses_A + imported_per_dose_B * doses_B
  <= imported_available;

constraint
  mrna_per_dose_A * doses_A + mrna_per_dose_B * doses_B
  <= mrna_available;

% --- Production relationship constraint (B must exceed A) ---
constraint
  doses_B > doses_A;

% --- Define total people treated based on produced doses ---
constraint
  total_people_treated
  = people_treated_per_dose_A * doses_A
  + people_treated_per_dose_B * doses_B;

% Objective
solve maximize total_people_treated;
% Parameters
% Resource usage per dose
int: imported_per_A = 30;
int: mrna_per_A = 50;
int: imported_per_B = 40;
int: mrna_per_B = 30;

% Resource capacities
int: imported_capacity = 300;
int: mrna_capacity = 400;

% Production limits / requirements
int: max_doses_A = 5;

% Treatment effectiveness (people treated per dose)
int: people_per_A = 12;
int: people_per_B = 8;

% Derived variable bounds (safe upper bounds from capacities)
int: max_doses_B =
  min(imported_capacity div imported_per_B, mrna_capacity div mrna_per_B);

% Variables
var 0..max_doses_A: doses_A;  % number of doses of medicine A
var 0..max_doses_B: doses_B;  % number of doses of medicine B

% Total number of people treated (bounded using max possible production)
var 0..(people_per_A * max_doses_A + people_per_B * max_doses_B): people_treated;

% Constraints
% Resource capacity constraints (imported material and mRNA)
constraint imported_per_A * doses_A + imported_per_B * doses_B <= imported_capacity;
constraint mrna_per_A * doses_A + mrna_per_B * doses_B <= mrna_capacity;

% Production relationship constraint (B must exceed A)
constraint doses_B > doses_A;

% Total people treated definition (linking variable)
constraint people_treated = people_per_A * doses_A + people_per_B * doses_B;

% Objective
solve maximize people_treated;
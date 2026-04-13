% Parameters (with values embedded)
int: max_imported = 300;
int: max_mrna = 400;

int: imported_per_A = 30;
int: mrna_per_A = 50;

int: imported_per_B = 40;
int: mrna_per_B = 30;

int: treat_per_A = 12;
int: treat_per_B = 8;

int: max_A = 5;

% Variables
var 0..max_A: doses_A;
var 0..10: doses_B; % upper bound from imported constraint: floor(300/40)=7, from mrna: floor(400/30)=13, plus B>A and A<=5 -> safe bound 10

% Constraints
constraint imported_per_A * doses_A + imported_per_B * doses_B <= max_imported;
constraint mrna_per_A * doses_A + mrna_per_B * doses_B <= max_mrna;

constraint doses_B > doses_A;

% Objective
solve maximize treat_per_A * doses_A + treat_per_B * doses_B;
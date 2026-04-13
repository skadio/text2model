% Parameters
int: vitC_per_shot = 30;
int: vitD_per_shot = 40;
int: vitC_per_pill = 50;
int: vitD_per_pill = 30;

int: vitC_available = 1200;
int: vitD_available = 1500;

int: people_per_shot = 10;
int: people_per_pill = 7;

int: max_shots = 10;

% Variables
var 0..max_shots: shots;
var 0..min(vitC_available div vitC_per_pill, vitD_available div vitD_per_pill): pills;

var 0..(people_per_shot*max_shots + people_per_pill*(min(vitC_available div vitC_per_pill, vitD_available div vitD_per_pill))): total_people;

% Constraints
constraint vitC_per_shot * shots + vitC_per_pill * pills <= vitC_available;
constraint vitD_per_shot * shots + vitD_per_pill * pills <= vitD_available;

constraint pills > shots;

constraint total_people = people_per_shot * shots + people_per_pill * pills;

% Objective
solve maximize total_people;
% Parameters (with values embedded)
int: vitC_available = 1200;
int: vitD_available = 1500;

int: vitC_per_shots = 30;
int: vitD_per_shots = 40;
int: vitC_per_pills = 50;
int: vitD_per_pills = 30;

int: people_per_shots = 10;
int: people_per_pills = 7;

int: max_shots_batches = 10;

% Variables
var 0..max_shots_batches: shots_batches;
var 0..50: pills_batches; % safe upper bound (limited by vitamin C: 1200/50 = 24)

% Constraints
constraint vitC_per_shots * shots_batches + vitC_per_pills * pills_batches <= vitC_available;
constraint vitD_per_shots * shots_batches + vitD_per_pills * pills_batches <= vitD_available;

% pills are more popular: strictly more pills batches than shots batches
constraint pills_batches >= shots_batches + 1;

% tighten pills upper bound via resources (redundant but helpful)
constraint pills_batches <= vitC_available div vitC_per_pills;
constraint pills_batches <= vitD_available div vitD_per_pills;

% Objective
var int: total_people = people_per_shots * shots_batches + people_per_pills * pills_batches;
solve maximize total_people;
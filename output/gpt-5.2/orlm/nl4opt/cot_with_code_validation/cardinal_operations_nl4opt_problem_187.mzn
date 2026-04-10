% Parameters
int: c_per_shot = 30;
int: d_per_shot = 40;
int: c_per_pill = 50;
int: d_per_pill = 30;

int: c_avail = 1200;
int: d_avail = 1500;

int: people_per_shot = 10;
int: people_per_pill = 7;

int: max_shots = 10;

% Variables
var 0..max_shots: shots;
var 0..min(c_avail div c_per_pill, d_avail div d_per_pill): pills;

var 0..(people_per_shot * max_shots + people_per_pill * (min(c_avail div c_per_pill, d_avail div d_per_pill))): total_people;

% Constraints
constraint c_per_shot * shots + c_per_pill * pills <= c_avail;
constraint d_per_shot * shots + d_per_pill * pills <= d_avail;

constraint pills > shots;

constraint total_people = people_per_shot * shots + people_per_pill * pills;

% Objective
solve maximize total_people;
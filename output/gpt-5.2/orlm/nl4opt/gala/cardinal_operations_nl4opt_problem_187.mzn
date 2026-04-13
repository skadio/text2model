% Vitamin shots & pills production optimization (all data embedded)

include "globals.mzn";

% Data
int: c_available = 1200;
int: d_available = 1500;

int: c_per_shot = 30;
int: d_per_shot = 40;

int: c_per_pill = 50;
int: d_per_pill = 30;

int: people_per_shot = 10;
int: people_per_pill = 7;

int: max_shots = 10;

% Decision variables: number of batches
var 0..max_shots: shots;
% Upper bound from vitamin C and D limits (safe tight-ish bound)
var 0..min(c_available div c_per_pill, d_available div d_per_pill): pills;

% Resource constraints
constraint c_per_shot * shots + c_per_pill * pills <= c_available;
constraint d_per_shot * shots + d_per_pill * pills <= d_available;

% Popularity constraint: pills > shots
constraint pills > shots;

% Objective: maximize people supplied
var 0..(people_per_shot*max_shots + people_per_pill*(min(c_available div c_per_pill, d_available div d_per_pill))): people;
constraint people = people_per_shot * shots + people_per_pill * pills;

solve maximize people;

output [
  "shots_batches = ", show(shots), "\n",
  "pills_batches = ", show(pills), "\n",
  "people_supplied = ", show(people), "\n",
  "vitaminC_used = ", show(c_per_shot*shots + c_per_pill*pills), " / ", show(c_available), "\n",
  "vitaminD_used = ", show(d_per_shot*shots + d_per_pill*pills), " / ", show(d_available), "\n"
];
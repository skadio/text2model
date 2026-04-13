% Parameters
int: audience_pop = 100;
int: audience_rnb = 240;
int: practice_pop = 2;
int: practice_rnb = 4;

int: min_audience = 10000;
int: max_practice_days = 180;

float: max_rnb_fraction = 0.4;

% Variables
var 0..(max_practice_days div practice_pop): pop_concerts;
var 0..(max_practice_days div practice_rnb): rnb_concerts;

var 0..((max_practice_days div practice_pop) + (max_practice_days div practice_rnb)): total_concerts;

% Constraints
constraint total_concerts = pop_concerts + rnb_concerts;

constraint audience_pop * pop_concerts + audience_rnb * rnb_concerts >= min_audience;

constraint practice_pop * pop_concerts + practice_rnb * rnb_concerts <= max_practice_days;

% At most 40% of concerts are R&B: rnb_concerts <= 0.4 * total_concerts
% Use integer form to avoid float variables: 5*rnb <= 2*total
constraint 5 * rnb_concerts <= 2 * total_concerts;

% Objective
solve minimize total_concerts;
% Parameters
int: pop_audience = 100;
int: pop_practice_days = 2;

int: rb_audience = 240;
int: rb_practice_days = 4;

int: min_audience = 10000;
int: max_practice_days = 180;

int: rb_percent_max_num = 40;
int: rb_percent_max_den = 100;

% Variables
var 0..(max_practice_days div pop_practice_days): pop_concerts;
var 0..(max_practice_days div rb_practice_days): rb_concerts;
var 0..(max_practice_days div pop_practice_days + max_practice_days div rb_practice_days): total_concerts;

% Constraints
constraint total_concerts = pop_concerts + rb_concerts;

constraint pop_audience * pop_concerts + rb_audience * rb_concerts >= min_audience;

constraint pop_practice_days * pop_concerts + rb_practice_days * rb_concerts <= max_practice_days;

% At most 40% of concerts are R&B:
% rb_concerts / (pop_concerts + rb_concerts) <= 40/100
constraint rb_percent_max_den * rb_concerts <= rb_percent_max_num * total_concerts;

% Objective
solve minimize total_concerts;
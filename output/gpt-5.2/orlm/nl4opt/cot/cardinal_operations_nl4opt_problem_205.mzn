% Parameters (with values embedded)
int: pop_audience = 100;
int: pop_days = 2;
int: rb_audience = 240;
int: rb_days = 4;

int: min_audience = 10000;
int: max_days = 180;

int: rb_max_percent = 40;

% Upper bounds derived from practice-day limit
int: max_pop = max_days div pop_days;   % 90
int: max_rb  = max_days div rb_days;    % 45

% Variables
var 0..max_pop: pop_concerts;
var 0..max_rb: rb_concerts;

% Constraints
constraint pop_audience * pop_concerts + rb_audience * rb_concerts >= min_audience;
constraint pop_days * pop_concerts + rb_days * rb_concerts <= max_days;

% At most 40% of total concerts are R&B: rb_concerts <= 0.4 * (pop_concerts + rb_concerts)
% Use integer form to avoid floats: 100*rb <= 40*(pop+rb)  <=> 60*rb <= 40*pop  <=> 3*rb <= 2*pop
constraint 3 * rb_concerts <= 2 * pop_concerts;

% Objective
solve minimize pop_concerts + rb_concerts;
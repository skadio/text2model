% Parameters
int: dough_large = 12;
int: top_large  = 5;
int: time_large = 12;

int: dough_med  = 8;
int: top_med    = 4;
int: time_med   = 8;

int: min_dough = 10000;
int: min_top   = 4400;

int: min_med = 200;

% Variables
var 0..10000: L; % number of large pizzas
var 0..10000: M; % number of medium pizzas
var 0..200000: total_time;

% Constraints
constraint dough_large * L + dough_med * M >= min_dough;
constraint top_large  * L + top_med  * M >= min_top;

constraint M >= min_med;
constraint L >= 2 * M;

constraint total_time = time_large * L + time_med * M;

% Objective
solve minimize total_time;
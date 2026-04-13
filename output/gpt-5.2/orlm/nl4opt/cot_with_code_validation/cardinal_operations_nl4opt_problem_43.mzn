% Parameters
int: letters_dual = 50;
int: letters_single = 30;
int: glue_dual = 20;
int: glue_single = 15;

int: min_letters = 300;
int: max_glue = 135;

% Variables
var 0..100: dual;
var 0..100: single;

var 0..200: total_machines;

% Constraints
constraint total_machines = dual + single;

constraint letters_dual * dual + letters_single * single >= min_letters;

constraint glue_dual * dual + glue_single * single <= max_glue;

constraint single > dual;

% Objective
solve minimize total_machines;
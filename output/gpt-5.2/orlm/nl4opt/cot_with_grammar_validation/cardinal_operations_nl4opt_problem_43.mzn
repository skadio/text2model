% Parameters
int: letters_per_dual = 50;
int: letters_per_single = 30;
int: glue_per_dual = 20;
int: glue_per_single = 15;

int: min_letters = 300;
int: max_glue = 135;

% Variables
var 0..ceil(max_glue div glue_per_dual): dual;
var 0..ceil(max_glue div glue_per_single): single;

% Constraints
constraint letters_per_dual * dual + letters_per_single * single >= min_letters;
constraint glue_per_dual * dual + glue_per_single * single <= max_glue;
constraint single > dual;

% Objective
solve minimize dual + single;
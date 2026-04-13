% Parameters (with values embedded)
int: letters_per_dual = 50;
int: letters_per_single = 30;
int: glue_per_dual = 20;
int: glue_per_single = 15;

int: min_letters = 300;
int: max_glue = 135;

% Variables
var 0..100: dual_machines;
var 0..100: single_machines;

% Constraints
constraint letters_per_dual * dual_machines + letters_per_single * single_machines >= min_letters;
constraint glue_per_dual * dual_machines + glue_per_single * single_machines <= max_glue;
constraint single_machines > dual_machines;

% Objective
solve minimize dual_machines + single_machines;
% Parameters
int: letters_dual = 50;
int: letters_single = 30;
int: glue_dual = 20;
int: glue_single = 15;

int: min_letters = 300;
int: max_glue = 135;

% Upper bounds derived from constraints:
% 20*dual + 15*single <= 135 => dual <= 6, single <= 9
int: max_dual = max_glue div glue_dual;
int: max_single = max_glue div glue_single;

% Variables
var 0..max_dual: dual;
var 0..max_single: single;

% Constraints
constraint
  letters_dual * dual + letters_single * single >= min_letters;

constraint
  glue_dual * dual + glue_single * single <= max_glue;

constraint
  single > dual;

% Objective
solve minimize dual + single;
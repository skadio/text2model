% Stamping machines purchase optimization (all data embedded)

int: dual_letters = 50;
int: single_letters = 30;

int: dual_glue = 20;
int: single_glue = 15;

int: min_letters = 300;
int: max_glue = 135;

var 0..100: dual;    % number of dual model machines
var 0..100: single;  % number of single model machines

constraint single > dual;

constraint dual_letters * dual + single_letters * single >= min_letters;
constraint dual_glue * dual + single_glue * single <= max_glue;

var int: total = dual + single;
solve minimize total;

output [
  "dual = ", show(dual), "\n",
  "single = ", show(single), "\n",
  "total = ", show(total), "\n",
  "letters_per_min = ", show(dual_letters*dual + single_letters*single), "\n",
  "glue_per_min = ", show(dual_glue*dual + single_glue*single), "\n"
];
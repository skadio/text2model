% Stamping machines optimization (all data embedded)

% Data
int: stamp_dual   = 50;   % letters/min
int: stamp_single = 30;

int: glue_dual    = 20;   % units/min
int: glue_single  = 15;

int: min_letters  = 300;
int: max_glue     = 135;

% Decision variables: number of machines to buy
var 0..100: dual;
var 0..100: single;

% Constraints
constraint stamp_dual * dual + stamp_single * single >= min_letters;
constraint glue_dual * dual + glue_single * single <= max_glue;

% Single machines must be more than dual machines
constraint single > dual;

% Objective: minimize total machines
var 0..200: total = dual + single;
solve minimize total;

output [
  "dual = ", show(dual), "\n",
  "single = ", show(single), "\n",
  "total = ", show(total), "\n",
  "letters_per_min = ", show(stamp_dual * dual + stamp_single * single), "\n",
  "glue_per_min = ", show(glue_dual * dual + glue_single * single), "\n"
];
% Parameters (with values embedded)
int: premium_pages_per_min = 30;
int: regular_pages_per_min = 20;
int: premium_ink_per_min = 4;
int: regular_ink_per_min = 3;

int: min_pages_per_min = 200;
int: max_ink_per_min = 35;

% Variables
var 0..100: premium_printers;
var 0..100: regular_printers;

% Constraints
constraint premium_pages_per_min * premium_printers
         + regular_pages_per_min * regular_printers >= min_pages_per_min;

constraint premium_ink_per_min * premium_printers
         + regular_ink_per_min * regular_printers <= max_ink_per_min;

constraint regular_printers < premium_printers;

% Objective
solve minimize premium_printers + regular_printers;
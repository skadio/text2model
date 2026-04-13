% Parameters
int: nTables = 2;

array[1..nTables] of int: powder_use = [3, 8];
array[1..nTables] of int: glue_use   = [5, 6];
array[1..nTables] of int: slime_prod = [4, 5];
array[1..nTables] of int: mess_prod  = [2, 4];

int: powder_avail = 100;
int: glue_avail   = 90;
int: mess_max     = 30;

% Variables
array[1..nTables] of var 0..100: x; % number of each table to set up

var 0..1000: total_slime;

% Constraints
constraint
  sum(i in 1..nTables)(powder_use[i] * x[i]) <= powder_avail;

constraint
  sum(i in 1..nTables)(glue_use[i] * x[i]) <= glue_avail;

constraint
  sum(i in 1..nTables)(mess_prod[i] * x[i]) <= mess_max;

constraint
  total_slime = sum(i in 1..nTables)(slime_prod[i] * x[i]);

% Objective
solve maximize total_slime;
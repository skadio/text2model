% Parameters (with values embedded)
int: nTables = 2;
set of int: T = 1..nTables;

array[T] of int: powder_use = [3, 8];
array[T] of int: glue_use   = [5, 6];
array[T] of int: slime_make = [4, 5];
array[T] of int: mess_make  = [2, 4];

int: powder_avail = 100;
int: glue_avail   = 90;
int: mess_max     = 30;

% Variables
array[T] of var 0..100: x;  % number of each table to set up (integer, nonnegative)

% Constraints
constraint sum(t in T)(powder_use[t] * x[t]) <= powder_avail;
constraint sum(t in T)(glue_use[t] * x[t])   <= glue_avail;
constraint sum(t in T)(mess_make[t] * x[t])  <= mess_max;

% Objective
var int: total_slime = sum(t in T)(slime_make[t] * x[t]);
solve maximize total_slime;
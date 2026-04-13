% Parameters
int: nTables = 2;

array[1..nTables] of int: powder_use = [3, 8];
array[1..nTables] of int: glue_use   = [5, 6];
array[1..nTables] of int: slime_out  = [4, 5];
array[1..nTables] of int: mess_out   = [2, 4];

int: powder_avail = 100;
int: glue_avail   = 90;
int: mess_max     = 30;

% Helper bounds (fixes max(int,int,int) error by using nested max)
int: ub_powder = powder_avail div min(powder_use);
int: ub_glue   = glue_avail div min(glue_use);
int: ub_mess   = mess_max div min(mess_out);
int: ub_tables = min([ub_powder, ub_glue, ub_mess]);

% Variables
array[1..nTables] of var 0..ub_tables: x;

var 0..(ub_tables * max(slime_out)): total_slime;

% Constraints
constraint sum(i in 1..nTables)(powder_use[i] * x[i]) <= powder_avail;
constraint sum(i in 1..nTables)(glue_use[i] * x[i])   <= glue_avail;
constraint sum(i in 1..nTables)(mess_out[i] * x[i])   <= mess_max;

constraint total_slime = sum(i in 1..nTables)(slime_out[i] * x[i]);

% Objective
solve maximize total_slime;

output [
  "x = ", show(x), "\n",
  "total_slime = ", show(total_slime), "\n"
];
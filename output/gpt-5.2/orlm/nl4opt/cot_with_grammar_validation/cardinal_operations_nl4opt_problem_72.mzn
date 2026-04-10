% Parameters
int: powder_avail = 100;
int: glue_avail = 90;
int: mess_max = 30;

int: powder1 = 3;
int: glue1 = 5;
int: slime1 = 4;
int: mess1 = 2;

int: powder2 = 8;
int: glue2 = 6;
int: slime2 = 5;
int: mess2 = 4;

% Variables
var 0..min(powder_avail div powder1, min(glue_avail div glue1, mess_max div mess1)): x1;
var 0..min(powder_avail div powder2, min(glue_avail div glue2, mess_max div mess2)): x2;

var 0..(slime1 * (powder_avail div powder1) + slime2 * (powder_avail div powder2)): total_slime;

% Constraints
constraint powder1 * x1 + powder2 * x2 <= powder_avail;
constraint glue1 * x1 + glue2 * x2 <= glue_avail;
constraint mess1 * x1 + mess2 * x2 <= mess_max;

constraint total_slime = slime1 * x1 + slime2 * x2;

% Objective
solve maximize total_slime;
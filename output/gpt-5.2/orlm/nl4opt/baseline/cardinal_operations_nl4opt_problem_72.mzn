% Slime production with two table types
% Maximize total slime produced subject to powder, glue, and mess limits.

int: powder_available = 100;
int: glue_available   = 90;
int: mess_limit       = 30;

% Table 1 parameters
int: powder1 = 3;
int: glue1   = 5;
int: slime1  = 4;
int: mess1   = 2;

% Table 2 parameters
int: powder2 = 8;
int: glue2   = 6;
int: slime2  = 5;
int: mess2   = 4;

% Decision variables: number of each table to set up (nonnegative integers)
var 0..powder_available div min(powder1, powder2): x1;
var 0..powder_available div min(powder1, powder2): x2;

constraint powder1 * x1 + powder2 * x2 <= powder_available;
constraint glue1   * x1 + glue2   * x2 <= glue_available;
constraint mess1   * x1 + mess2   * x2 <= mess_limit;

var int: total_slime = slime1 * x1 + slime2 * x2;

solve maximize total_slime;

output [
  "Table1=", show(x1), "\n",
  "Table2=", show(x2), "\n",
  "TotalSlime=", show(total_slime), "\n",
  "PowderUsed=", show(powder1*x1 + powder2*x2), " / ", show(powder_available), "\n",
  "GlueUsed=", show(glue1*x1 + glue2*x2), " / ", show(glue_available), "\n",
  "MessMade=", show(mess1*x1 + mess2*x2), " / ", show(mess_limit), "\n"
];
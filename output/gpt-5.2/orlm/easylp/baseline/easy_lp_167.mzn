% Marketing budget allocation problem (all data embedded)

int: total_budget = 1000;

int: min_diff_XY = 100;  % X >= Y + 100
int: min_diff_YZ = 50;   % Y >= Z + 50

int: ret_X = 10;  % return units per $ for X
int: ret_Y = 15;  % return units per $ for Y
int: ret_Z = 20;  % return units per $ for Z

var 0..total_budget: X;
var 0..total_budget: Y;
var 0..total_budget: Z;

constraint X + Y + Z <= total_budget;
constraint X >= Y + min_diff_XY;
constraint Y >= Z + min_diff_YZ;

var int: total_return = ret_X * X + ret_Y * Y + ret_Z * Z;

solve minimize total_return;

output [
  "X=$", show(X), "\n",
  "Y=$", show(Y), "\n",
  "Z=$", show(Z), "\n",
  "Minimum expected returns (units) = ", show(total_return), "\n"
];
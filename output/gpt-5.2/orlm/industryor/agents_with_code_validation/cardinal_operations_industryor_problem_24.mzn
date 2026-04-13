% Parameters
int: total_capital = 100000;

% Return multipliers
% Option 1: after 1 year, each 1 yuan becomes 0.7 yuan
float: r1 = 0.7;

% Option 2: after 2 years, each 1 yuan becomes 2 yuan
float: r2 = 2.0;

int: horizon_years = 3;

% Variables
var float: x1_y1; % invest option 1 at start of year 1 -> end of year 1
var float: x1_y2; % invest option 1 at start of year 2 -> end of year 2
var float: x1_y3; % invest option 1 at start of year 3 -> end of year 3

var float: x2_y1; % invest option 2 at start of year 1 -> end of year 2
var float: x2_y2; % invest option 2 at start of year 2 -> end of year 3

var float: cash_y1;
var float: cash_y2;
var float: cash_y3;

var float: final_wealth;

% Constraints: non-negativity
constraint x1_y1 >= 0.0 /\ x1_y2 >= 0.0 /\ x1_y3 >= 0.0;
constraint x2_y1 >= 0.0 /\ x2_y2 >= 0.0;
constraint cash_y1 >= 0.0 /\ cash_y2 >= 0.0 /\ cash_y3 >= 0.0;
constraint final_wealth >= 0.0;

% Cash flow constraints
constraint cash_y1 = int2float(total_capital);
constraint cash_y2 = r1 * x1_y1;
constraint cash_y3 = r1 * x1_y2 + r2 * x2_y1;

% Budget constraints
constraint x1_y1 + x2_y1 <= cash_y1;
constraint x1_y2 + x2_y2 <= cash_y2;
constraint x1_y3 <= cash_y3;

% Final wealth at end of year 3
constraint final_wealth = r1 * x1_y3 + r2 * x2_y2;

% Objective
solve maximize final_wealth;
% Parameters (with values embedded)
int: total_capital = 100000;
float: r1 = 0.7;   % return after 1 year per 1 yuan in option 1
float: r2 = 2.0;   % return after 2 years per 1 yuan in option 2

% Variables
var 0..total_capital: x1; % yuan invested in option 1 at start of year 0 (matures end of year 1)
var 0..total_capital: x2; % yuan invested in option 2 at start of year 0 (matures end of year 2)
var 0..total_capital: x3; % yuan reinvested in option 1 at start of year 1 (from proceeds at end of year 1)
var 0..total_capital: x4; % yuan invested in option 1 at start of year 2 (from proceeds at end of year 2)
var float: final_money;   % total money available at end of year 3

% Constraints
constraint x1 + x2 <= total_capital;

% At start of year 1, only proceeds from x1 are available for re-investment (option 2 not allowed since must be 2-year multiples)
constraint x3 <= r1 * x1;

% At start of year 2, proceeds from option 2 (x2) plus proceeds from year-1 option-1 investment (x3) are available
constraint x4 <= r2 * x2 + r1 * x3;

% Money at end of year 3 comes from year-2 option-1 investment only
constraint final_money = r1 * x4;

% Objective
solve maximize final_money;
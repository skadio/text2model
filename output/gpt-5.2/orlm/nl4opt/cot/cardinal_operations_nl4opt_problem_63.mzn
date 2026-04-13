% Parameters (with values embedded)
int: max_hours = 3000;

float: mixer_time_bread = 1.0;
float: oven_time_bread  = 3.0;

float: mixer_time_cookies = 0.5;
float: oven_time_cookies  = 1.0;

int: profit_bread = 5;
int: profit_cookies = 3;

% Variables
var 0..max_hours: bread;           % number of loaves of bread (integer, nonnegative)
var 0..(2*max_hours): cookies;     % number of cookie batches (integer, nonnegative)

% Constraints
constraint mixer_time_bread * int2float(bread) + mixer_time_cookies * int2float(cookies) <= int2float(max_hours);
constraint oven_time_bread  * int2float(bread) + oven_time_cookies  * int2float(cookies) <= int2float(max_hours);

% Objective
var int: total_profit = profit_bread * bread + profit_cookies * cookies;
solve maximize total_profit;
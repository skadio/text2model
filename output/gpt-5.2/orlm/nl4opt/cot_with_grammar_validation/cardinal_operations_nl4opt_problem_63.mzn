% Parameters
int: max_hours = 3000;

float: mixer_hours_bread = 1.0;
float: oven_hours_bread  = 3.0;

float: mixer_hours_cookies = 0.5;
float: oven_hours_cookies  = 1.0;

int: profit_bread = 5;
int: profit_cookies = 3;

% Variables
var 0..100000: bread;
var 0..100000: cookies;

% Constraints
constraint mixer_hours_bread * int2float(bread) + mixer_hours_cookies * int2float(cookies) <= int2float(max_hours);
constraint oven_hours_bread  * int2float(bread) + oven_hours_cookies  * int2float(cookies) <= int2float(max_hours);

% Objective
solve maximize profit_bread * bread + profit_cookies * cookies;
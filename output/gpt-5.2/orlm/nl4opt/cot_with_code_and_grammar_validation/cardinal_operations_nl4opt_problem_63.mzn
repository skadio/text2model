% Parameters
int: max_hours_mixer = 3000;
int: max_hours_oven  = 3000;

float: mixer_per_bread = 1.0;
float: oven_per_bread  = 3.0;
float: profit_bread    = 5.0;

float: mixer_per_cookies = 0.5;
float: oven_per_cookies  = 1.0;
float: profit_cookies    = 3.0;

% Variables
var 0..max_hours_mixer: bread;
var 0..(2 * max_hours_mixer): cookies;

var float: total_profit;

% Constraints
constraint
  mixer_per_bread * int2float(bread) + mixer_per_cookies * int2float(cookies)
  <= int2float(max_hours_mixer);

constraint
  oven_per_bread * int2float(bread) + oven_per_cookies * int2float(cookies)
  <= int2float(max_hours_oven);

constraint
  total_profit = profit_bread * int2float(bread) + profit_cookies * int2float(cookies);

% Objective
solve maximize total_profit;
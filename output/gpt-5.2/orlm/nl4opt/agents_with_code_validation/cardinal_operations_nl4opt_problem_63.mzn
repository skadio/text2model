% Bakery production planning (LP)

% Parameters
int: max_mixer_hours = 3000;
int: max_oven_hours  = 3000;

float: mixer_hours_per_bread   = 1.0;
float: oven_hours_per_bread    = 3.0;
float: mixer_hours_per_cookies = 0.5;
float: oven_hours_per_cookies  = 1.0;

float: profit_per_bread   = 5.0;
float: profit_per_cookies = 3.0;

% Decision variables (nonnegative production quantities)
var 0.0..infinity: bread_loaves;
var 0.0..infinity: cookie_batches;

% Objective
solve maximize profit_per_bread * bread_loaves
             + profit_per_cookies * cookie_batches;

% Constraints
constraint mixer_hours_per_bread   * bread_loaves
         + mixer_hours_per_cookies * cookie_batches
         <= max_mixer_hours;

constraint oven_hours_per_bread * bread_loaves
         + oven_hours_per_cookies * cookie_batches
         <= max_oven_hours;
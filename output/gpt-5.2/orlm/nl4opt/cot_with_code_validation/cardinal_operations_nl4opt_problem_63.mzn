% Parameters
int: max_hours = 3000;

float: mixer_bread = 1.0;
float: oven_bread  = 3.0;

float: mixer_cookies = 0.5;
float: oven_cookies  = 1.0;

int: profit_bread = 5;
int: profit_cookies = 3;

% Variables
var 0..6000: bread;    % limited by oven: 3*bread <= 3000 => bread <= 1000; mixer allows up to 3000
var 0..6000: cookies;  % limited by mixer: 0.5*cookies <= 3000 => cookies <= 6000; oven allows up to 3000

% Constraints
constraint mixer_bread * bread + mixer_cookies * cookies <= max_hours;
constraint oven_bread  * bread + oven_cookies  * cookies <= max_hours;

% Objective
solve maximize profit_bread * bread + profit_cookies * cookies;
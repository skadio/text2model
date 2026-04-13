% Parameters (with values embedded)
int: min_choc = 5;
int: min_van  = 5;
int: max_choc = 10;
int: max_van  = 8;

int: hours_per_choc = 1;
int: hours_per_van  = 2;
int: total_hours    = 30;

int: workers_per_choc = 1;
int: workers_per_van  = 2;
int: min_workers      = 6;

int: profit_choc = 200;
int: profit_van  = 300;

% Variables
var 0..max_choc: choc;  % gallons of chocolate
var 0..max_van:  van;   % gallons of vanilla

% Constraints
constraint choc >= min_choc;
constraint van  >= min_van;

constraint hours_per_choc * choc + hours_per_van * van <= total_hours;

% Interpreting "at least 6 workers are needed with 1 working on chocolate and 2 on vanilla"
% as total worker requirement proportional to production amounts.
constraint workers_per_choc * choc + workers_per_van * van >= min_workers;

% Objective
solve maximize profit_choc * choc + profit_van * van;
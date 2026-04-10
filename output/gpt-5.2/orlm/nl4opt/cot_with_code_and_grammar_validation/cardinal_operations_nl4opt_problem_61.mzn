% Parameters
int: premium_ppm = 30;      % pages per minute per premium printer
int: regular_ppm = 20;      % pages per minute per regular printer
int: premium_ink = 4;       % ink units per minute per premium printer
int: regular_ink = 3;       % ink units per minute per regular printer
int: min_pages = 200;       % minimum total pages per minute
int: max_ink = 35;          % maximum total ink units per minute

% Upper bounds derived from ink constraint (since variables are non-negative integers)
int: max_premium = max_ink div premium_ink;  % <= 8
int: max_regular = max_ink div regular_ink;  % <= 11

% Variables
var 0..max_premium: premium;
var 0..max_regular: regular;

% Constraints
constraint premium_ppm * premium + regular_ppm * regular >= min_pages;
constraint premium_ink * premium + regular_ink * regular <= max_ink;
constraint regular < premium;

% Objective
solve minimize premium + regular;
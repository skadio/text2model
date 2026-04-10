% Parameters
int: premium_ppm = 30;
int: regular_ppm = 20;
int: premium_ink = 4;
int: regular_ink = 3;

int: min_pages = 200;
int: max_ink = 35;

% Variables
var 0..(max_ink div premium_ink): premium;
var 0..(max_ink div regular_ink): regular;
var 0..(max_ink div min(premium_ink, regular_ink)): total;

% Constraints
constraint premium * premium_ppm + regular * regular_ppm >= min_pages;
constraint premium * premium_ink + regular * regular_ink <= max_ink;
constraint regular < premium;

constraint total = premium + regular;

% Objective
solve minimize total;
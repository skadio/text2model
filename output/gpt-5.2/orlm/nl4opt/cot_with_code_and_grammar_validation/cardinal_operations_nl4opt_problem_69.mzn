% Parameters
int: cap_wide = 25;
int: cap_narrow = 15;
int: demand = 900;
int: min_wide = 5;

% Variables
var 0..demand div cap_wide + 1000: wide;
var 0..demand div cap_narrow + 1000: narrow;
var 0..(demand div min(cap_wide, cap_narrow) + 2000): total_pipes;

% Constraints
constraint wide >= min_wide;

constraint cap_wide * wide + cap_narrow * narrow >= demand;

% wide <= (1/3) * narrow  <=>  3*wide <= narrow
constraint 3 * wide <= narrow;

constraint total_pipes = wide + narrow;

% Objective
solve minimize total_pipes;
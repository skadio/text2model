% Parameters
int: kids_capacity_ml = 100;        % ml per kids bottle
int: adult_capacity_ml = 300;       % ml per adult bottle
int: total_syrup_ml = 25000;        % total ml available
int: min_kids_bottles = 50;         % at least this many kids bottles
int: adult_to_kids_ratio = 3;       % adult bottles must be at least 3 times kids bottles

% Upper bounds derived from syrup availability (safe integer bounds)
int: max_kids_bottles = total_syrup_ml div kids_capacity_ml;
int: max_adult_bottles = total_syrup_ml div adult_capacity_ml;

% Variables
var min_kids_bottles..max_kids_bottles: kids_bottles;   % number of kids bottles to make
var 0..max_adult_bottles: adult_bottles;                % number of adult bottles to make
var 0..(max_kids_bottles + max_adult_bottles): total_bottles; % total bottles made

% Constraints

% Bottle count aggregation
constraint
  total_bottles = kids_bottles + adult_bottles;

% Syrup availability (do not exceed total syrup)
constraint
  kids_capacity_ml * kids_bottles + adult_capacity_ml * adult_bottles <= total_syrup_ml;

% Production ratio: at least 3 times as many adult bottles as kids bottles
constraint
  adult_bottles >= adult_to_kids_ratio * kids_bottles;

% Minimum kids bottles requirement (already enforced by variable domain, restated for clarity)
constraint
  kids_bottles >= min_kids_bottles;

% Objective
solve maximize total_bottles;
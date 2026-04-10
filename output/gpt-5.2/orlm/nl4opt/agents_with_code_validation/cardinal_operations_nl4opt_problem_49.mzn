% Parameters
int: kids_capacity_ml = 100;          % ml per kids bottle
int: adult_capacity_ml = 300;         % ml per adult bottle
int: total_syrup_ml = 25000;          % total ml of syrup available
int: adult_to_kids_ratio = 3;         % adult bottles must be at least this multiple of kids bottles
int: min_kids_bottles = 50;           % minimum kids bottles to produce

% Variables
var 0..(total_syrup_ml div kids_capacity_ml): kids_bottles;    % number of kids bottles
var 0..(total_syrup_ml div adult_capacity_ml): adult_bottles;  % number of adult bottles
var 0..(total_syrup_ml div kids_capacity_ml): total_bottles;   % total bottles produced

% Constraints
% Total syrup used by both bottle types cannot exceed availability
constraint
  kids_capacity_ml * kids_bottles + adult_capacity_ml * adult_bottles <= total_syrup_ml;

% At least adult_to_kids_ratio times as many adult bottles as kids bottles
constraint
  adult_bottles >= adult_to_kids_ratio * kids_bottles;

% At least min_kids_bottles kids bottles must be made
constraint
  kids_bottles >= min_kids_bottles;

% Total bottles equals the sum of kids and adult bottles
constraint
  total_bottles = kids_bottles + adult_bottles;

% Objective
solve maximize total_bottles;
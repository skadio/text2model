% Parameters
int: n;                             % number of bottle types
set of int: TYPES = 1..n;           
array[TYPES] of int: b;             % number of bottles of each type
array[TYPES] of int: t;             % liquid units in each bottle type
int: num_people;                    % number of people
set of int: PEOPLE = 1..num_people;

% Derived constants
int: total_bottles = sum(i in TYPES)(b[i]);
int: total_liquid  = sum(i in TYPES)(t[i] * b[i]);
int: max_bottle    = max(i in TYPES)(b[i]);
int: max_bottles_per_person = total_bottles;   % safe upper bound
int: max_liquid_per_person  = total_liquid;    % safe upper bound

% Variables
array[TYPES, PEOPLE] of var 0..max_bottle: x;  % allocation of bottles
var 0..max_bottles_per_person: bottles_per_person;
var 0..max_liquid_per_person : liquid_per_person;

% Constraints
%
% Each bottle is assigned exactly once
constraint
  forall(i in TYPES)(
    sum(j in PEOPLE)(x[i,j]) = b[i]
  );

% Per–type capacity upper bounds
constraint
  forall(i in TYPES, j in PEOPLE)(
    x[i,j] <= b[i]
  );

% Equal number of bottles for every person
constraint
  forall(j in PEOPLE)(
    sum(i in TYPES)(x[i,j]) = bottles_per_person
  );

% Equal amount of liquid for every person
constraint
  forall(j in PEOPLE)(
    sum(i in TYPES)(t[i] * x[i,j]) = liquid_per_person
  );

% Consistency with global totals
constraint
  num_people * bottles_per_person = total_bottles /\
  num_people * liquid_per_person  = total_liquid;

% Lexicographical ordering of allocations to break symmetry
constraint
  forall(j in 1..num_people-1)(
    lex_lesseq([x[i,j] | i in TYPES],
               [x[i,j+1] | i in TYPES])
  );

% Objective
solve satisfy;
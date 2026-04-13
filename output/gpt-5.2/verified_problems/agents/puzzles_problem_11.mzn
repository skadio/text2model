% Parameters
int: n;                                 % Number of bottle types
array[1..n] of int: b;                  % Number of bottles available of each type
array[1..n] of int: t;                  % Fill amount/type indicator for each bottle type (as given in data)
int: num_people;                        % Number of people

% Useful derived index sets
set of int: TYPES  = 1..n;
set of int: PEOPLE = 1..num_people;


% Variables
array[PEOPLE, TYPES] of var 0..max(b): x;     % x[p,i] = number of bottles of type i given to person p

var 0..sum(b): bottles_per_person;            % Common number of bottles each person receives
var int: liquid_per_person;                   % Common total liquid amount each person receives (in units of t)


% Constraints
% Basic sanity constraints on input parameters (kept as constraints)
constraint forall(i in TYPES) (b[i] >= 0);
constraint forall(i in TYPES) (t[i] >= 0);
constraint num_people >= 1;

% Explicit bounds/definitions for key variables
constraint bottles_per_person >= 0;
constraint bottles_per_person <= sum(b);

% Availability / capacity: total assigned of each type cannot exceed stock
constraint
  forall(i in TYPES)(
    sum(p in PEOPLE)(x[p,i]) <= b[i]
  );

% Equal number of bottles per person
constraint
  forall(p in PEOPLE)(
    sum(i in TYPES)(x[p,i]) = bottles_per_person
  );

% Equal total liquid amount per person (liquid measured in units of t)
constraint
  forall(p in PEOPLE)(
    sum(i in TYPES)(x[p,i] * t[i]) = liquid_per_person
  );

% Symmetry breaking: allocations (rows) in nondecreasing lexicographic order
constraint
  forall(p in 1..num_people-1)(
    lex_lesseq([x[p,i] | i in TYPES], [x[p+1,i] | i in TYPES])
  );

% Tightening: totals match the per-person values
constraint
  sum(p in PEOPLE, i in TYPES)(x[p,i]) = num_people * bottles_per_person;

constraint
  sum(p in PEOPLE, i in TYPES)(x[p,i] * t[i]) = num_people * liquid_per_person;


% Objective
solve maximize bottles_per_person;
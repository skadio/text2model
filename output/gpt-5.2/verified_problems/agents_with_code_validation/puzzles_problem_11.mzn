% Parameters
int: n;                                   % Number of bottle types
set of int: TYPES = 1..n;                 % Index set for bottle types

array[TYPES] of int: b;                   % Number of bottles available of each type
array[TYPES] of int: t;                   % Fill amount/type descriptor for each bottle type (as provided)

int: num_people;                          % Number of people to distribute bottles to
set of int: PEOPLE = 1..num_people;       % Index set for people

% Variables
array[PEOPLE, TYPES] of var 0..sum(b): x; % x[p,i] = number of bottles of type i given to person p

var 0..sum(b): bottles_per_person;        % Equal number of bottles each person receives
var int: liquid_per_person;               % Equal total liquid amount each person receives (in units of t)

% Constraints

% --- Feasibility: allocate exactly all bottles of each type ---
constraint
  forall(i in TYPES) (
    sum(p in PEOPLE)(x[p,i]) = b[i]
  );

% --- Equal number of bottles per person ---
constraint
  forall(p in PEOPLE) (
    sum(i in TYPES)(x[p,i]) = bottles_per_person
  );

% --- Equal total liquid amount per person (liquid measured in units of t) ---
constraint
  forall(p in PEOPLE) (
    sum(i in TYPES)(x[p,i] * t[i]) = liquid_per_person
  );

% --- Symmetry breaking: allocations in lexicographical order across people ---
constraint
  forall(p in 1..num_people-1) (
    lex_lesseq([x[p,i] | i in TYPES], [x[p+1,i] | i in TYPES])
  );

% Objective
solve satisfy;
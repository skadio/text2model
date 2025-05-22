% Parameters
include "globals.mzn";

int: n;
set of int: TYPES = 1..n;

array[TYPES] of int: b;       % Number of bottles of each type
array[TYPES] of int: t;       % Amount of liquid in each bottle type

int: num_people;
set of int: PEOPLE = 1..num_people;

int: total_bottles = sum(i in TYPES)(b[i]);
int: total_liquid  = sum(i in TYPES)(b[i] * t[i]);

constraint total_bottles mod num_people == 0;
constraint total_liquid  mod num_people == 0;

int: bottles_per_person = total_bottles div num_people;
int: liquid_per_person  = total_liquid  div num_people;

% Variables
array[PEOPLE, TYPES] of var int: x;   % x[p,i] = bottles of type i given to person p

% Constraints
constraint
    forall(p in PEOPLE, i in TYPES)(
        0 <= x[p,i] /\ x[p,i] <= b[i]
    );

constraint
    forall(i in TYPES)(
        sum(p in PEOPLE)(x[p,i]) == b[i]
    );

constraint
    forall(p in PEOPLE)(
        sum(i in TYPES)(x[p,i]) == bottles_per_person
    );

constraint
    forall(p in PEOPLE)(
        sum(i in TYPES)(t[i] * x[p,i]) == liquid_per_person
    );

constraint
    forall(p in PEOPLE where p < num_people)(
        lex_lesseq([x[p,i] | i in TYPES],
                   [x[p+1,i] | i in TYPES])
    );

% Objective
solve satisfy;
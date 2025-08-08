include "globals.mzn";

% Parameters from the data file
int: n;               % Number of bottle types
array[1..n] of int: b;  % Number of bottles for each bottle type
array[1..n] of int: t;  % Liquid amount (scaled integer value) for each bottle type
int: num_people;      % Number of people

% Derived values
int: total_bottles = sum(b);
int: bottles_per_person = total_bottles div num_people;
int: total_liquid = sum(i in 1..n)( b[i] * t[i] );
int: liquid_per_person = total_liquid div num_people;

% Decision variable:
% alloc[p,i] is the number of bottles of type i given to person p.
% The domain of alloc[p,i] is from 0 up to b[i] (cannot assign more bottles of type i than exist).
array[1..num_people, 1..n] of var int: alloc;

% Each allocation must be within the available bottles per type.
constraint forall(p in 1..num_people, i in 1..n)(
    alloc[p,i] >= 0 /\ alloc[p,i] <= b[i]
);

% Constraint 1: All bottles of each type must be distributed.
constraint forall(i in 1..n)(
    sum(p in 1..num_people)( alloc[p,i] ) = b[i]
);

% Constraint 2: Each person gets the same total number of bottles.
constraint forall(p in 1..num_people)(
    sum(i in 1..n)( alloc[p,i] ) = bottles_per_person
);

% Constraint 3: Each person gets the same total liquid.
constraint forall(p in 1..num_people)(
    sum(i in 1..n)( alloc[p,i] * t[i] ) = liquid_per_person
);

% Constraint 4: Lexicographical ordering of allocations across people.
% This ensures that the rows of the allocation matrix are in non-decreasing lex order.
constraint forall(p in 1..num_people-1)(
    lex_lesseq([alloc[p,j] | j in 1..n], [alloc[p+1,j] | j in 1..n])
);

solve satisfy;

output [
    "Allocation Matrix (rows: people, columns: bottle types):\n", 
    show(alloc), "\n"
];
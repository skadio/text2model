% Bottle distribution with equal number of bottles and equal total liquid per person.
% No transferring liquid between bottles.
% Allocations are forced to be lexicographically nondecreasing across people.

include "globals.mzn";

% ----- Input -----
int: n;                             % number of bottle types
array[1..n] of int: b;              % available bottles of each type
array[1..n] of int: t;              % liquid amount of each type (as integer units)
int: num_people;                    % number of people

set of int: TYPES = 1..n;
set of int: PEOPLE = 1..num_people;

% ----- Decision variables -----
% x[p,i] = number of bottles of type i given to person p
array[PEOPLE, TYPES] of var 0..max(b): x;

% ----- Feasibility constraints -----
% Cannot use more bottles than available
constraint forall(i in TYPES)(
  sum(p in PEOPLE)(x[p,i]) <= b[i]
);

% Each person gets the same number of bottles
var int: k = sum(i in TYPES)(x[1,i]);
constraint forall(p in PEOPLE)(
  sum(i in TYPES)(x[p,i]) = k
);

% Each person gets the same amount of liquid
var int: L = sum(i in TYPES)(x[1,i] * t[i]);
constraint forall(p in PEOPLE)(
  sum(i in TYPES)(x[p,i] * t[i]) = L
);

% Optional implied constraints (strengthening)
constraint k >= 0;
constraint L >= 0;

% ----- Lexicographic order of allocations (nondecreasing across people) -----
% Vector for person p: [x[p,1], x[p,2], ..., x[p,n]]
constraint forall(p in 1..num_people-1)(
  lex_lesseq([x[p,i] | i in TYPES], [x[p+1,i] | i in TYPES])
);

solve satisfy;

output [
  "k (bottles per person) = ", show(k), "\n",
  "L (liquid per person)  = ", show(L), "\n",
  "Allocation x[p,i] (people x types):\n",
  concat([
    "person ", show(p), ": ",
    show([ x[p,i] | i in TYPES ]),
    "\n"
  | p in PEOPLE])
];
% Production planning LP (as MILP/LP-style with integer hours)
% Maximize completed products from 3 components produced in 4 workshops.

include "globals.mzn";

set of int: W = 1..4;   % workshops: 1=A, 2=B, 3=C, 4=D
set of int: C = 1..3;   % components: 1,2,3

array[W] of string: wname = ["A","B","C","D"];

% Data from Table 1.4
array[W] of int: cap = [100, 150, 80, 200]; % hours available per workshop

% rate[w,c] = units of component c produced per hour in workshop w
array[W, C] of int: rate =
  array2d(W, C, [
    10, 15,  5,   % A
    15, 10,  5,   % B
    20,  5, 10,   % C
    10, 15, 20    % D
  ]);

% Decision variables:
% h[w,c] = hours workshop w allocates to component c
array[W, C] of var 0..200: h;

% Total output per component across all workshops
array[C] of var 0..100000: produced;

% Number of completed products (needs 1 of each component)
var 0..100000: products;

% Capacity constraints (each workshop has limited hours)
constraint forall(w in W)(
  sum(c in C)(h[w,c]) <= cap[w]
);

% Production accounting
constraint forall(c in C)(
  produced[c] = sum(w in W)( rate[w,c] * h[w,c] )
);

% Products limited by availability of each component
constraint forall(c in C)(
  products <= produced[c]
);

solve maximize products;

output [
  "Max products = ", show(products), "\n\n",
  "Hours allocation h[w,c] (rows workshops A-D, cols components 1-3):\n",
  concat([ wname[w] ++ ": " ++ show([h[w,c] | c in C]) ++ "\n" | w in W ]),
  "\nProduced components: ", show([produced[c] | c in C]), "\n"
];
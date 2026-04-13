int: S;              % slots per template
int: t;              % number of templates
int: n;              % number of variations
array[1..n] of int: d;  % demand per variation

set of int: TEMPL = 1..t;
set of int: VAR = 1..n;

% x[i,j] = number of slots on template i assigned to variation j
array[TEMPL, VAR] of var 0..S: x;

% total produced of each variation (each template is used once)
array[VAR] of var 0..t*S: produced =
  [ sum(i in TEMPL)(x[i,j]) | j in VAR ];

% Surplus above demand (counted only when produced exceeds demand)
array[VAR] of var 0..t*S: surplus_j =
  [ max(0, produced[j] - d[j]) | j in VAR ];

var 0..t*S*n: surplus = sum(j in VAR)(surplus_j[j]);

constraint
  forall(i in TEMPL)(
    sum(j in VAR)(x[i,j]) = S
  );

constraint
  forall(j in VAR)(
    produced[j] >= d[j]
  );

% Lexicographic nondecreasing order of templates by their slot-count vectors
constraint
  forall(i in 1..t-1)(
    lex_lesseq([x[i,j] | j in VAR], [x[i+1,j] | j in VAR])
  );

solve minimize surplus;

output [
  "surplus = ", show(surplus), "\n",
  "produced = ", show(produced), "\n",
  "x =\n",
  concat([ "template " ++ show(i) ++ ": " ++ show([x[i,j] | j in VAR]) ++ "\n" | i in TEMPL ])
];
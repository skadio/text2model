% Parameters
int: raw_len = 10;
int: n_types = 2;
set of int: TYPES = 1..n_types;

array[TYPES] of int: piece_len = [3, 4];
array[TYPES] of int: demand = [90, 60];

% Enumerate all feasible cutting patterns for a 10m bar:
% pattern p is defined by (a3[p], a4[p]) with 3*a3 + 4*a4 <= 10
int: n_patterns = 6;
set of int: PATS = 1..n_patterns;

array[PATS] of int: a3 = [0, 0, 0, 1, 2, 3];
array[PATS] of int: a4 = [0, 1, 2, 1, 1, 1];

array[PATS] of int: used_len = [ raw_len - (raw_len - (3*a3[p] + 4*a4[p])) | p in PATS ];
array[PATS] of int: waste = [ raw_len - (3*a3[p] + 4*a4[p]) | p in PATS ];

% Upper bound on number of raw bars (crude but safe): assume worst case 1 piece per bar
int: UB_bars = sum(t in TYPES)(demand[t]);

% Variables
array[PATS] of var 0..UB_bars: x;  % number of raw bars cut with pattern p

% Constraints
constraint
  sum(p in PATS)(a3[p] * x[p]) = demand[1];

constraint
  sum(p in PATS)(a4[p] * x[p]) = demand[2];

% Objective
solve minimize sum(p in PATS)(waste[p] * x[p]);
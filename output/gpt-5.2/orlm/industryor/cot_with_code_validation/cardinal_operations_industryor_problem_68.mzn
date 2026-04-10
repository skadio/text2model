% Steel cutting stock: 10m raw bars, demands for 3m and 4m pieces
int: raw_len = 10;

int: n_types = 2;
array[1..n_types] of int: piece_len = [3, 4];
array[1..n_types] of int: demand    = [90, 60];

% Enumerate all feasible cutting patterns for one raw bar:
% a = number of 3m pieces, b = number of 4m pieces
int: max_a = raw_len div piece_len[1];
int: max_b = raw_len div piece_len[2];

set of int: A = 0..max_a;
set of int: B = 0..max_b;

set of (int,int): FEAS = { (a,b) | a in A, b in B where a*piece_len[1] + b*piece_len[2] <= raw_len };
int: n_pat = card(FEAS);
set of int: PAT = 1..n_pat;

array[PAT] of int: pat_a =
  array1d(PAT, [ a | (a,b) in FEAS ]);
array[PAT] of int: pat_b =
  array1d(PAT, [ b | (a,b) in FEAS ]);
array[PAT] of int: pat_waste =
  array1d(PAT, [ raw_len - (a*piece_len[1] + b*piece_len[2]) | (a,b) in FEAS ]);

% Variables: number of raw bars cut with each pattern
array[PAT] of var 0..sum(demand): x;

% Constraints: meet demands (can overproduce)
constraint sum(p in PAT)(pat_a[p] * x[p]) >= demand[1];
constraint sum(p in PAT)(pat_b[p] * x[p]) >= demand[2];

% Objective: minimize total waste
var 0..raw_len * sum(demand): total_waste = sum(p in PAT)(pat_waste[p] * x[p]);

solve minimize total_waste;

% Optional output
output [
  "total_waste = ", show(total_waste), "\n",
  "patterns (a=3m, b=4m, waste):\n",
  concat([ "p", show(p), ": (", show(pat_a[p]), ",", show(pat_b[p]), "), waste=", show(pat_waste[p]),
           ", x=", show(x[p]), "\n"
         | p in PAT ])
];
% Factory production planning: maximize profit with routing and capacity constraints
% All data embedded.

set of int: P = 1..3;          % Products: 1=I, 2=II, 3=III
set of int: A = 1..2;          % Stage A equipment: 1=A1, 2=A2
set of int: B = 1..3;          % Stage B equipment: 1=B1, 2=B2, 3=B3

array[P] of string: pname = ["I","II","III"];
array[A] of string: aname = ["A1","A2"];
array[B] of string: bname = ["B1","B2","B3"];

% Processing time per piece (in minutes). Use a large number to represent "not allowed".
int: BIG = 1000000;

array[A,P] of int: tA = array2d(A,P, [
  5, 10, BIG,   % A1: I, II, III(not allowed)
  7,  9,  12    % A2: I, II, III
]);

array[B,P] of int: tB = array2d(B,P, [
  6,  8, BIG,   % B1: I, II, III(not allowed)
  4, BIG, 11,   % B2: I, II(not allowed), III
  7, BIG, BIG   % B3: I, II(not allowed), III(not allowed)
]);

% Effective machine hours available
array[A] of int: capA_hours = [6000, 10000];
array[B] of int: capB_hours = [4000, 7000, 4000];

% Convert to minutes capacity
array[A] of int: capA = [capA_hours[a] * 60 | a in A];
array[B] of int: capB = [capB_hours[b] * 60 | b in B];

% Processing cost per machine hour (Yuan/hour)
array[A] of float: costA_hr = [0.05, 0.03];
array[B] of float: costB_hr = [0.06, 0.11, 0.05];

% Convert to Yuan/minute
array[A] of float: costA_min = [costA_hr[a] / 60.0 | a in A];
array[B] of float: costB_min = [costB_hr[b] / 60.0 | b in B];

% Raw material cost per piece (Yuan/piece)
array[P] of float: raw = [0.25, 0.35, 0.5];

% Unit sales price (Yuan/piece)
array[P] of float: price = [1.25, 2.0, 2.8];

% Decision variables:
% xA[a,p] = number of pieces of product p processed on A equipment a
% xB[b,p] = number of pieces of product p processed on B equipment b
array[A,P] of var int: xA;
array[B,P] of var int: xB;

% Total production of each product
array[P] of var int: q;

% Nonnegativity and feasibility with routing restrictions (forbidden routes must have zero flow)
constraint forall(a in A, p in P) (
  xA[a,p] >= 0 /\ (tA[a,p] >= BIG -> xA[a,p] = 0)
);
constraint forall(b in B, p in P) (
  xB[b,p] >= 0 /\ (tB[b,p] >= BIG -> xB[b,p] = 0)
);

% Flow conservation between stages: produced quantity equals amount processed in each stage
constraint forall(p in P) (
  q[p] = sum(a in A)(xA[a,p]) /\
  q[p] = sum(b in B)(xB[b,p])
);

% Capacity constraints (minutes of processing)
constraint forall(a in A)(
  sum(p in P)(tA[a,p] * xA[a,p]) <= capA[a]
);
constraint forall(b in B)(
  sum(p in P)(tB[b,p] * xB[b,p]) <= capB[b]
);

% Objective: maximize profit = revenue - raw materials - processing costs
var float: revenue = sum(p in P)(price[p] * int2float(q[p]));
var float: raw_cost = sum(p in P)(raw[p] * int2float(q[p]));

var float: proc_cost_A = sum(a in A, p in P)(
  costA_min[a] * int2float(tA[a,p]) * int2float(xA[a,p])
);
var float: proc_cost_B = sum(b in B, p in P)(
  costB_min[b] * int2float(tB[b,p]) * int2float(xB[b,p])
);

var float: profit = revenue - raw_cost - proc_cost_A - proc_cost_B;

solve maximize profit;

output [
  "Profit = ", show(profit), "\n",
  "Revenue = ", show(revenue), "\n",
  "Raw cost = ", show(raw_cost), "\n",
  "Processing cost A = ", show(proc_cost_A), "\n",
  "Processing cost B = ", show(proc_cost_B), "\n\n",
  "Quantities (pieces):\n",
  concat([ "  Product " ++ pname[p] ++ ": " ++ show(q[p]) ++ "\n" | p in P ]),
  "\nStage A allocation (pieces):\n",
  concat([ "  " ++ aname[a] ++ " -> Product " ++ pname[p] ++ ": " ++ show(xA[a,p]) ++ "\n"
           | a in A, p in P ]),
  "\nStage B allocation (pieces):\n",
  concat([ "  " ++ bname[b] ++ " -> Product " ++ pname[p] ++ ": " ++ show(xB[b,p]) ++ "\n"
           | b in B, p in P ])
];
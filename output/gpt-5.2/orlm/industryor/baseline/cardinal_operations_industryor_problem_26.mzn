% Factory production planning: maximize profit with routing through A then B machines.

set of int: P = 1..3;         % products: 1=I, 2=II, 3=III
set of int: A = 1..2;         % A machines: 1=A1, 2=A2
set of int: B = 1..3;         % B machines: 1=B1, 2=B2, 3=B3

array[P] of string: pname = ["I","II","III"];
array[A] of string: aname = ["A1","A2"];
array[B] of string: bname = ["B1","B2","B3"];

% Processing time (per unit) on machines; 0 means "not allowed / not available"
array[A, P] of int: tA = array2d(A, P,
[
  5, 10,  0,   % A1: I, II, III(not allowed)
  7,  9, 12    % A2: I, II, III
]);

array[B, P] of int: tB = array2d(B, P,
[
  6,  8,  0,   % B1: I, II, III(not allowed)
  4,  0, 11,   % B2: I, II(not allowed), III
  7,  0,  0    % B3: I, II(not allowed), III(not allowed)
]);

% Effective machine hours (capacity)
array[A] of int: capA = [6000, 10000];
array[B] of int: capB = [4000, 7000, 4000];

% Operating cost at full capacity
array[A] of float: costFullA = [300.0, 321.0];
array[B] of float: costFullB = [250.0, 783.0, 200.0];

% Raw material cost and sale price per unit
array[P] of float: rawCost  = [0.25, 0.35, 0.50];
array[P] of float: unitPrice = [1.25, 2.00, 2.80];

% Decision: units of product p processed on machine a (process A) and b (process B)
array[A, P] of var int: xA;
array[B, P] of var int: xB;

constraint forall(a in A, p in P) (
  xA[a,p] >= 0 /\ (tA[a,p] = 0 -> xA[a,p] = 0)
);
constraint forall(b in B, p in P) (
  xB[b,p] >= 0 /\ (tB[b,p] = 0 -> xB[b,p] = 0)
);

% Flow conservation: each produced unit must do A and B exactly once
array[P] of var int: prod;
constraint forall(p in P) (
  prod[p] = sum(a in A)(xA[a,p]) /\
  prod[p] = sum(b in B)(xB[b,p])
);

% Capacity constraints (time usage cannot exceed effective hours)
constraint forall(a in A) (
  sum(p in P)(tA[a,p] * xA[a,p]) <= capA[a]
);
constraint forall(b in B) (
  sum(p in P)(tB[b,p] * xB[b,p]) <= capB[b]
);

% Operating cost proportional to utilization (full-capacity cost scales linearly)
var float: opCost =
  sum(a in A)( costFullA[a] * (int2float(sum(p in P)(tA[a,p] * xA[a,p])) / int2float(capA[a])) ) +
  sum(b in B)( costFullB[b] * (int2float(sum(p in P)(tB[b,p] * xB[b,p])) / int2float(capB[b])) );

var float: revenue = sum(p in P)( unitPrice[p] * int2float(prod[p]) );
var float: material = sum(p in P)( rawCost[p] * int2float(prod[p]) );

var float: profit = revenue - material - opCost;

solve maximize profit;

output [
  "Profit = ", show(profit), "\n",
  "Revenue = ", show(revenue), "\n",
  "MaterialCost = ", show(material), "\n",
  "OperatingCost = ", show(opCost), "\n\n",
  "Production (units):\n",
  concat([ "  Product " ++ pname[p] ++ ": " ++ show(prod[p]) ++ "\n" | p in P ]),
  "\nProcess A allocation (units):\n",
  concat([ "  " ++ aname[a] ++ ", Product " ++ pname[p] ++ ": " ++ show(xA[a,p]) ++ "\n"
           | a in A, p in P ]),
  "\nProcess B allocation (units):\n",
  concat([ "  " ++ bname[b] ++ ", Product " ++ pname[p] ++ ": " ++ show(xB[b,p]) ++ "\n"
           | b in B, p in P ]),
  "\nMachine utilizations (time used / capacity):\n",
  concat([ "  " ++ aname[a] ++ ": " ++
           show(sum(p in P)(tA[a,p] * xA[a,p])) ++ " / " ++ show(capA[a]) ++ "\n"
           | a in A ]),
  concat([ "  " ++ bname[b] ++ ": " ++
           show(sum(p in P)(tB[b,p] * xB[b,p])) ++ " / " ++ show(capB[b]) ++ "\n"
           | b in B ])
];
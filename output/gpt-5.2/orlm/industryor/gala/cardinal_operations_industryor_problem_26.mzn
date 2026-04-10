% Factory production planning (maximize profit)
% Data embedded as given in Table 1-4.

include "globals.mzn";

%----------------------------
% Sets
%----------------------------
set of int: P = 1..3; % products: 1=I, 2=II, 3=III
set of int: A = 1..2; % machines for process A: 1=A1, 2=A2
set of int: B = 1..3; % machines for process B: 1=B1, 2=B2, 3=B3

array[P] of string: pname = ["I","II","III"];
array[A] of string: aname = ["A1","A2"];
array[B] of string: bname = ["B1","B2","B3"];

%----------------------------
% Data
%----------------------------
% Processing time (hours per unit). 0 means "not allowed / not applicable".
array[A, P] of int: tA = array2d(A, P, [
  5, 10,  0,   % A1: I, II, III(not allowed)
  7,  9, 12    % A2: I, II, III
]);

array[B, P] of int: tB = array2d(B, P, [
  6,  8,  0,   % B1: I, II, III(not allowed)
  4,  0, 11,   % B2: I, II(not allowed), III
  7,  0,  0    % B3: I, II(not allowed), III(not allowed)
]);

array[A] of int: capA = [6000, 10000]; % effective machine hours
array[B] of int: capB = [4000, 7000, 4000];

% Operating costs at full capacity (Yuan) for each machine
array[A] of float: opCostA = [300.0, 321.0];
array[B] of float: opCostB = [250.0, 783.0, 200.0];

% Product economics (Yuan per unit)
array[P] of float: rawCost  = [0.25, 0.35, 0.50];
array[P] of float: price    = [1.25, 2.00, 2.80];
array[P] of float: margin   = [ price[p] - rawCost[p] | p in P ];

%----------------------------
% Decisions
%----------------------------
% xA[a,p] = units of product p processed on A-machine a
% xB[b,p] = units of product p processed on B-machine b
%
% Choose a safe upper bound for integer units based on smallest processing times:
% (cap / min_time) across all allowed machines gives an upper bound; use a generous one.
int: UB = 100000;

array[A, P] of var 0..UB: xA;
array[B, P] of var 0..UB: xB;

% Total production units per product (must match between A and B)
array[P] of var 0..UB: q;

% Machine usage in hours
array[A] of var 0..max(capA): useA;
array[B] of var 0..max(capB): useB;

%----------------------------
% Feasibility / routing constraints (enforce allowed machines)
%----------------------------
constraint forall(a in A, p in P where tA[a,p] = 0)( xA[a,p] = 0 );
constraint forall(b in B, p in P where tB[b,p] = 0)( xB[b,p] = 0 );

% Define totals q[p] and flow conservation between processes A and B
constraint forall(p in P)(
  q[p] = sum(a in A)(xA[a,p])
);
constraint forall(p in P)(
  q[p] = sum(b in B)(xB[b,p])
);

%----------------------------
% Capacity constraints (machine hours)
%----------------------------
constraint forall(a in A)(
  useA[a] = sum(p in P)( tA[a,p] * xA[a,p] ) /\
  useA[a] <= capA[a]
);

constraint forall(b in B)(
  useB[b] = sum(p in P)( tB[b,p] * xB[b,p] ) /\
  useB[b] <= capB[b]
);

%----------------------------
% Objective: maximize profit
% Profit = sum_p margin[p]*q[p] - sum_m opCost[m]*(usage/capacity)
% Operating cost scales linearly with utilization (full cost at full capacity).
% Use float objective; all times/capacities are in hours.
%----------------------------
var float: revenueMinusRaw = sum(p in P)( margin[p] * int2float(q[p]) );

var float: operatingCost =
  sum(a in A)( opCostA[a] * (int2float(useA[a]) / int2float(capA[a])) ) +
  sum(b in B)( opCostB[b] * (int2float(useB[b]) / int2float(capB[b])) );

var float: profit = revenueMinusRaw - operatingCost;

solve maximize profit;

%----------------------------
% Output
%----------------------------
output
[
  "Optimal profit (Yuan) = ", show(profit), "\n",
  "Production quantities q (units):\n",
  concat([ "  Product " ++ pname[p] ++ ": " ++ show(q[p]) ++ "\n" | p in P ]),
  "Process A allocation (units):\n",
  concat([ "  " ++ aname[a] ++ ": " ++
           concat([ pname[p] ++ "=" ++ show(xA[a,p]) ++ (if p<max(P) then ", " else "" endif)
                    | p in P ]) ++
           " | hours=" ++ show(useA[a]) ++ "/" ++ show(capA[a]) ++ "\n"
         | a in A ]),
  "Process B allocation (units):\n",
  concat([ "  " ++ bname[b] ++ ": " ++
           concat([ pname[p] ++ "=" ++ show(xB[b,p]) ++ (if p<max(P) then ", " else "" endif)
                    | p in P ]) ++
           " | hours=" ++ show(useB[b]) ++ "/" ++ show(capB[b]) ++ "\n"
         | b in B ]),
  "Revenue - raw material cost = ", show(revenueMinusRaw), "\n",
  "Operating cost = ", show(operatingCost), "\n"
];
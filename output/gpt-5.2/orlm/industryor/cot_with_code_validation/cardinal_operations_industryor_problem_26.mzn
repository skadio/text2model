% Factory production planning - maximize profit
% Data embedded (no .dzn needed)

int: nProd = 3;
set of int: PROD = 1..nProd; % 1=I, 2=II, 3=III

int: nA = 2;
set of int: A = 1..nA; % 1=A1, 2=A2

int: nB = 3;
set of int: B = 1..nB; % 1=B1, 2=B2, 3=B3

% Processing times (hours per unit); 0 means not allowed on that machine
array[A, PROD] of int: tA = array2d(A, PROD,
  [ 5, 10, 0,    % A1: I, II, III(not allowed)
    7,  9, 12    % A2: I, II, III
  ]);

array[B, PROD] of int: tB = array2d(B, PROD,
  [ 6,  8, 0,    % B1: I, II, III(not allowed)
    4,  0, 11,   % B2: I, II(not allowed), III
    7,  0, 0     % B3: I, II(not allowed), III(not allowed)
  ]);

% Effective machine hours available
array[A] of int: capA = [6000, 10000];
array[B] of int: capB = [4000, 7000, 4000];

% Operating costs at full capacity (Yuan)
array[A] of float: costFullA = [300.0, 321.0];
array[B] of float: costFullB = [250.0, 783.0, 200.0];

% Raw material cost and unit sale price (Yuan/unit)
array[PROD] of float: rawCost = [0.25, 0.35, 0.50];
array[PROD] of float: price   = [1.25, 2.00, 2.80];

% Upper bounds on production (tight, per product, based on feasible machines)
int: UB1 = min([capA[1] div tA[1,1], capA[2] div tA[2,1],
                capB[1] div tB[1,1], capB[2] div tB[2,1], capB[3] div tB[3,1]]);
int: UB2 = min([capA[1] div tA[1,2], capA[2] div tA[2,2],
                capB[1] div tB[1,2]]); % II uses B1 only
int: UB3 = min([capA[2] div tA[2,3],
                capB[2] div tB[2,3]]); % III uses A2 and B2 only
array[PROD] of int: UB = [UB1, UB2, UB3];

% Decision variables
array[PROD] of var 0..UB[p]: x;         % units produced of each product
array[A, PROD] of var 0..max(UB): xA;   % units of product p processed on A machine a
array[B, PROD] of var 0..max(UB): xB;   % units of product p processed on B machine b

% Machine hours used (integer hours since times/capacities are integers)
array[A] of var 0..max(capA): usedA;
array[B] of var 0..max(capB): usedB;

% Constraints: disallow infeasible assignments
constraint forall(a in A, p in PROD where tA[a,p] = 0)(xA[a,p] = 0);
constraint forall(b in B, p in PROD where tB[b,p] = 0)(xB[b,p] = 0);

% Flow balance: each unit must be processed exactly once in A and once in B
constraint forall(p in PROD)(sum(a in A)(xA[a,p]) = x[p]);
constraint forall(p in PROD)(sum(b in B)(xB[b,p]) = x[p]);

% Define machine hours used and respect capacities
constraint forall(a in A)(
  usedA[a] = sum(p in PROD)(tA[a,p] * xA[a,p]) /\
  usedA[a] <= capA[a]
);
constraint forall(b in B)(
  usedB[b] = sum(p in PROD)(tB[b,p] * xB[b,p]) /\
  usedB[b] <= capB[b]
);

% Profit (float) = contribution margin - operating cost proportional to utilization
% operating cost = costFull * (used/cap)
var float: profit =
  sum(p in PROD)((price[p] - rawCost[p]) * int2float(x[p]))
  - sum(a in A)(costFullA[a] * (int2float(usedA[a]) / int2float(capA[a])))
  - sum(b in B)(costFullB[b] * (int2float(usedB[b]) / int2float(capB[b])));

solve maximize profit;

output [
  "x(I,II,III) = ", show([x[p] | p in PROD]), "\n",
  "usedA(A1,A2) = ", show([usedA[a] | a in A]), "\n",
  "usedB(B1,B2,B3) = ", show([usedB[b] | b in B]), "\n",
  "profit = ", show(profit), "\n"
];
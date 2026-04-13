% Parameters (with values embedded)
int: P = 3; % products: 1=I, 2=II, 3=III
set of int: PRODUCTS = 1..P;

int: NA = 2; % A equipment: 1=A1, 2=A2
set of int: A = 1..NA;

int: NB = 3; % B equipment: 1=B1, 2=B2, 3=B3
set of int: B = 1..NB;

array[PRODUCTS] of float: rawCost = [0.25, 0.35, 0.5];
array[PRODUCTS] of float: unitPrice = [1.25, 2.0, 2.8];

array[A] of int: A_hours = [6000, 10000];
array[A] of float: A_costPerHour = [0.05, 0.03];

array[B] of int: B_hours = [4000, 7000, 4000];
array[B] of float: B_costPerHour = [0.06, 0.11, 0.05];

% processing time per piece (minutes); 0 means not allowed / not applicable
array[A, PRODUCTS] of int: tA =
 [| 5, 10,  0,   % A1
    7,  9, 12 |]; % A2

array[B, PRODUCTS] of int: tB =
 [| 6,  8,  0,   % B1
    4,  0, 11,   % B2
    7,  0,  0 |]; % B3

% Big-M bounds for production (integer pieces)
% Use maximum possible from A and B capacity bounds (in minutes) as a safe upper bound.
int: M_A = max([A_hours[a] * 60 div max(1, min([tA[a,p] | p in PRODUCTS where tA[a,p] > 0])) | a in A]);
int: M_B = max([B_hours[b] * 60 div max(1, min([tB[b,p] | p in PRODUCTS where tB[b,p] > 0])) | b in B]);
int: M = max(M_A, M_B);

% Variables
array[A, PRODUCTS] of var 0..M: xA; % pieces of product p processed on A equipment a
array[B, PRODUCTS] of var 0..M: xB; % pieces of product p processed on B equipment b
array[PRODUCTS] of var 0..M: x;     % total pieces produced of each product

var float: profit;

% Constraints
% Disallow forbidden processing routes (time=0)
constraint forall(a in A, p in PRODUCTS where tA[a,p] = 0)(xA[a,p] = 0);
constraint forall(b in B, p in PRODUCTS where tB[b,p] = 0)(xB[b,p] = 0);

% Flow consistency: stage A total equals produced quantity; stage B total equals produced quantity
constraint forall(p in PRODUCTS)(
  sum(a in A)(xA[a,p]) = x[p]
);
constraint forall(p in PRODUCTS)(
  sum(b in B)(xB[b,p]) = x[p]
);

% Machine hour capacities (convert to minutes)
constraint forall(a in A)(
  sum(p in PRODUCTS)(tA[a,p] * xA[a,p]) <= A_hours[a] * 60
);
constraint forall(b in B)(
  sum(p in PRODUCTS)(tB[b,p] * xB[b,p]) <= B_hours[b] * 60
);

% Profit definition:
% revenue - raw material - processing costs (machine-hour cost * used minutes/60)
constraint
  profit =
    sum(p in PRODUCTS)(unitPrice[p] * int2float(x[p]))
  - sum(p in PRODUCTS)(rawCost[p] * int2float(x[p]))
  - sum(a in A, p in PRODUCTS)(A_costPerHour[a] * (int2float(tA[a,p]) * int2float(xA[a,p]) / 60.0))
  - sum(b in B, p in PRODUCTS)(B_costPerHour[b] * (int2float(tB[b,p]) * int2float(xB[b,p]) / 60.0));

% Objective
solve maximize profit;
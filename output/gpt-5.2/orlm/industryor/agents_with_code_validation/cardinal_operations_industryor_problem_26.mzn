% Factory production planning - maximize profit
% All data embedded (no .dzn)

%%%%%%%%%%%%
% Sets
%%%%%%%%%%%%
int: nP = 3; set of int: P = 1..nP;      % products: 1=I,2=II,3=III
int: nA = 2; set of int: A = 1..nA;      % A machines: 1=A1,2=A2
int: nB = 3; set of int: B = 1..nB;      % B machines: 1=B1,2=B2,3=B3

%%%%%%%%%%%%
% Data
%%%%%%%%%%%%
% Processing times (hours per unit); 0 => infeasible combination
array[A,P] of int: timeA = array2d(A,P, [
  5, 10,  0,   % A1
  7,  9, 12    % A2
]);

array[B,P] of int: timeB = array2d(B,P, [
  6,  8,  0,   % B1
  4,  0, 11,   % B2
  7,  0,  0    % B3
]);

array[A] of int: hoursA = [6000, 10000];
array[B] of int: hoursB = [4000, 7000, 4000];

array[A] of float: fullCostA = [300.0, 321.0];
array[B] of float: fullCostB = [250.0, 783.0, 200.0];

array[P] of float: rawCost = [0.25, 0.35, 0.50];
array[P] of float: price   = [1.25, 2.00, 2.80];

%%%%%%%%%%%%
% Safe upper bounds (avoid expensive comprehensions that can cause timeout)
%%%%%%%%%%%%
% Loose but valid global upper bound on units:
% Each unit needs >=1 hour on some feasible machine in A and in B, and total hours are limited.
int: UB =
  min( sum(a in A)(hoursA[a]),
       sum(b in B)(hoursB[b]) );

%%%%%%%%%%%%
% Decision variables (integer units)
%%%%%%%%%%%%
array[A,P] of var 0..UB: xA;   % units of product p processed on A-machine a
array[B,P] of var 0..UB: xB;   % units of product p processed on B-machine b
array[P]   of var 0..UB: prod; % total units produced of product p

array[A] of var 0..sum(a in A)(hoursA[a]): usedHoursA;
array[B] of var 0..sum(b in B)(hoursB[b]): usedHoursB;

var float: profit;

%%%%%%%%%%%%
% Constraints
%%%%%%%%%%%%

% Link: each produced unit must be processed once in A and once in B
constraint forall(p in P) (
  prod[p] = sum(a in A)(xA[a,p])
);
constraint forall(p in P) (
  prod[p] = sum(b in B)(xB[b,p])
);

% Infeasible combinations forced to 0
constraint forall(a in A, p in P where timeA[a,p] = 0) ( xA[a,p] = 0 );
constraint forall(b in B, p in P where timeB[b,p] = 0) ( xB[b,p] = 0 );

% Machine hours used
constraint forall(a in A) (
  usedHoursA[a] = sum(p in P)(xA[a,p] * timeA[a,p])
);
constraint forall(b in B) (
  usedHoursB[b] = sum(p in P)(xB[b,p] * timeB[b,p])
);

% Capacity constraints
constraint forall(a in A) ( usedHoursA[a] <= hoursA[a] );
constraint forall(b in B) ( usedHoursB[b] <= hoursB[b] );

% Profit: revenue - raw material - prorated operating costs
constraint profit =
    sum(p in P)((price[p] - rawCost[p]) * int2float(prod[p]))
  - sum(a in A)(fullCostA[a] * (int2float(usedHoursA[a]) / int2float(hoursA[a])))
  - sum(b in B)(fullCostB[b] * (int2float(usedHoursB[b]) / int2float(hoursB[b])));

%%%%%%%%%%%%
% Objective
%%%%%%%%%%%%
solve maximize profit;
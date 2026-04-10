% Parameters (with values embedded)
int: P = 3; % products: 1=I, 2=II, 3=III
set of int: Products = 1..P;

int: A = 2; % A-machines: 1=A1, 2=A2
set of int: AMachines = 1..A;

int: B = 3; % B-machines: 1=B1, 2=B2, 3=B3
set of int: BMachines = 1..B;

array[AMachines, Products] of int: timeA =
| 5, 10, 0  % A1 for (I,II,III) ; 0 = not allowed
| 7,  9, 12 % A2
|;

array[BMachines, Products] of int: timeB =
| 6,  8, 0  % B1
| 4,  0, 11 % B2
| 7,  0, 0  % B3
|;

array[AMachines] of int: hoursA = [6000, 10000];
array[BMachines] of int: hoursB = [4000, 7000, 4000];

array[AMachines] of float: opCostAFull = [300.0, 321.0];
array[BMachines] of float: opCostBFull = [250.0, 783.0, 200.0];

array[Products] of float: rawCost = [0.25, 0.35, 0.50];
array[Products] of float: price   = [1.25, 2.00, 2.80];

% Operating cost per machine-hour (assuming linear with utilization)
array[AMachines] of float: opCostPerHourA = [opCostAFull[i] / float(hoursA[i]) | i in AMachines];
array[BMachines] of float: opCostPerHourB = [opCostBFull[j] / float(hoursB[j]) | j in BMachines];

% Upper bounds on production quantities (safe bounds from machine capacities)
int: UB_I   = min([hoursA[1] div 5, hoursA[2] div 7, hoursB[1] div 6, hoursB[2] div 4, hoursB[3] div 7]);
int: UB_II  = min([hoursA[1] div 10, hoursA[2] div 9, hoursB[1] div 8]);
int: UB_III = min([hoursA[2] div 12, hoursB[2] div 11]);

array[Products] of int: UB = [UB_I, UB_II, UB_III];

% Variables
array[Products] of var 0..max(UB): x; % units produced of each product

array[AMachines, Products] of var 0..max(UB): xA; % units of product p processed on A-machine i
array[BMachines, Products] of var 0..max(UB): xB; % units of product p processed on B-machine j

% Constraints
% Disallow assignments on infeasible machine-product pairs
constraint forall(i in AMachines, p in Products where timeA[i,p] = 0)( xA[i,p] = 0 );
constraint forall(j in BMachines, p in Products where timeB[j,p] = 0)( xB[j,p] = 0 );

% Flow conservation: each unit must complete A and B (possibly split across eligible machines)
constraint forall(p in Products)(
  sum(i in AMachines)(xA[i,p]) = x[p]
);
constraint forall(p in Products)(
  sum(j in BMachines)(xB[j,p]) = x[p]
);

% Machine-hour capacities
constraint forall(i in AMachines)(
  sum(p in Products)( timeA[i,p] * xA[i,p] ) <= hoursA[i]
);
constraint forall(j in BMachines)(
  sum(p in Products)( timeB[j,p] * xB[j,p] ) <= hoursB[j]
);

% Explicit product bounds
constraint forall(p in Products)( x[p] <= UB[p] );

% Objective
var float: revenue = sum(p in Products)( price[p] * float(x[p]) );
var float: material_cost = sum(p in Products)( rawCost[p] * float(x[p]) );

var float: op_cost =
  sum(i in AMachines)( opCostPerHourA[i] * sum(p in Products)( float(timeA[i,p]) * float(xA[i,p]) ) ) +
  sum(j in BMachines)( opCostPerHourB[j] * sum(p in Products)( float(timeB[j,p]) * float(xB[j,p]) ) );

var float: profit = revenue - material_cost - op_cost;

solve maximize profit;
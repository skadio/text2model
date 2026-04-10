% Parameters (with values embedded)
int: nProducts = 2;
set of int: P = 1..nProducts;

int: A_total = 1345;
int: B_total = 346;
int: C_total = 1643;

array[P] of int: A_req = [46, 13];   % Oil Max, Oil Max Pro
array[P] of int: B_req = [43, 4];
array[P] of int: C_req = [56, 45];

array[P] of int: profit = [10, 15];

% Variables
array[P] of var 0..10000: x; % x[1]=Oil Max containers, x[2]=Oil Max Pro containers

% Constraints
constraint sum(p in P)(A_req[p] * x[p]) <= A_total;
constraint sum(p in P)(B_req[p] * x[p]) <= B_total;
constraint sum(p in P)(C_req[p] * x[p]) <= C_total;

% Objective
var int: total_profit = sum(p in P)(profit[p] * x[p]);

solve maximize total_profit;
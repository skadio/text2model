% Parameters
% Fixed process indices
int: n = 4;
set of int: P = 1..n;

% Cost per unit allocation for each process (x1..x4)
array[P] of int: cost = [2, 3, 5, 4];

% Capacity/budget limits
int: cap12 = 1000;   % x1 + x2 <= 1000
int: cap34 = 1200;   % x3 + x4 <= 1200

% Ratio/balance constraints (handled via integer-multiplied forms)
% x1 >= (4/3) * x3  <=>  3*x1 >= 4*x3
int: r13_num = 4;
int: r13_den = 3;

% x2 >= (9/7) * x4 + 200  <=>  7*x2 >= 9*x4 + 7*200
int: r24_num = 9;
int: r24_den = 7;
int: extra24 = 200;

% Lower bound on each process allocation (nonnegative)
int: lb = 0;


% Variables
% Integer allocations to each process: x[1]=x1, x[2]=x2, x[3]=x3, x[4]=x4
array[P] of var int: x;

% Total cost to minimize
var int: total_cost;


% Constraints
% --- Domain / bounds constraints ---
constraint forall(p in P) (x[p] >= lb);

% --- Capacity / budget constraints ---
constraint x[1] + x[2] <= cap12;   % x1 + x2 cannot exceed 1000
constraint x[3] + x[4] <= cap34;   % x3 + x4 cannot exceed 1200

% --- Ratio / balance constraints (integer-multiplied to avoid fractions) ---
constraint r13_den * x[1] >= r13_num * x[3];  % 3*x1 >= 4*x3
constraint r24_den * x[2] >= r24_num * x[4] + r24_den * extra24; % 7*x2 >= 9*x4 + 1400

% --- Total cost definition ---
constraint total_cost = sum(p in P) (cost[p] * x[p]);


% Objective
solve minimize total_cost;
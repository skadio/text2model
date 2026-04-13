% Parameters (with values embedded)
int: initial_fund = 300000;

% Project return multipliers
% (1) yearly reinvestable project: 20% annual profit
float: r1 = 1.2;
% (2) invest at start year 1, recover end year 2: total 150%
float: r2 = 1.5;
int: cap2 = 150000;
% (3) invest at start year 2, recover end year 3: total 160%
float: r3 = 1.6;
int: cap3 = 200000;
% (4) invest at start year 3, recover in one year (end year 3): 40% profit
float: r4 = 1.4;
int: cap4 = 100000;

% Variables
% x1[t] = amount invested in project (1) at beginning of year t (t=1..3)
array[1..3] of var 0..initial_fund: x1;

% x2 = amount invested in project (2) at beginning of year 1
var 0..cap2: x2;

% x3 = amount invested in project (3) at beginning of year 2
var 0..cap3: x3;

% x4 = amount invested in project (4) at beginning of year 3
var 0..cap4: x4;

% cash at the beginning of each year (available to invest)
array[1..3] of var 0..initial_fund*10: cash;

% cash at the end of year 3 (objective)
var 0..initial_fund*10: final_amount;

% Constraints
constraint cash[1] = initial_fund;
constraint x1[1] + x2 <= cash[1];

constraint cash[2] = r1 * x1[1];
constraint x1[2] + x3 <= cash[2];

constraint cash[3] = r1 * x1[2] + r2 * x2;
constraint x1[3] + x4 <= cash[3];

constraint final_amount = r1 * x1[3] + r3 * x3 + r4 * x4;

% Objective
solve maximize final_amount;
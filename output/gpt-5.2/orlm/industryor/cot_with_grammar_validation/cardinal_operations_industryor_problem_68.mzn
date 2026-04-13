% Parameters
int: demand3 = 90;
int: demand4 = 60;
int: rawLen = 10;
int: len3 = 3;
int: len4 = 4;

% all feasible cutting patterns (x = #3m pieces, y = #4m pieces) with 3x + 4y <= 10
int: P = 6;
array[1..P] of int: pat3 = [0, 1, 2, 3, 0, 2];
array[1..P] of int: pat4 = [0, 0, 0, 0, 1, 1];
array[1..P] of int: waste = [10, 7, 4, 1, 6, 0];

% Variables
array[1..P] of var 0..(demand3 + demand4): use; % number of 10m raw bars cut with each pattern

% Constraints
constraint sum(p in 1..P)(pat3[p] * use[p]) = demand3;
constraint sum(p in 1..P)(pat4[p] * use[p]) = demand4;

% Objective
var 0..(rawLen * (demand3 + demand4)): totalWaste = sum(p in 1..P)(waste[p] * use[p]);

solve minimize totalWaste;
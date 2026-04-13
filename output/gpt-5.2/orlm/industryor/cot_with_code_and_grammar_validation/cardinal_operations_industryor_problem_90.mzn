% Parameters
int: profitA = 3;
int: profitB = 5;

int: timeA = 12;          % minutes per unit of A
int: timeB = 25;          % minutes per unit of B
int: weeklyTime = 30 * 60; % minutes available per week

% Variables
var 0..weeklyTime div timeA: xA;
var 0..weeklyTime div timeB: xB;

% Constraints
constraint timeA * xA + timeB * xB <= weeklyTime;

% For every 5 units of A, at least 2 units of B: xB >= (2/5)*xA
constraint 5 * xB >= 2 * xA;

% Objective
solve maximize profitA * xA + profitB * xB;
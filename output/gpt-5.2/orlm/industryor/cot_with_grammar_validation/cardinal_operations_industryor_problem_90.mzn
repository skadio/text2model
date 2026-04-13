% Parameters
int: profitA = 3;
int: profitB = 5;

int: timeA = 12;          % minutes per unit of A
int: timeB = 25;          % minutes per unit of B
int: weeklyTime = 30 * 60; % minutes available per week

% ratio constraint: for every 5 units of A, at least 2 units of B
int: ratioA = 5;
int: ratioB = 2;

% Variables
var 0..weeklyTime div timeA: xA; % units of product A
var 0..weeklyTime div timeB: xB; % units of product B

% Constraints
constraint timeA * xA + timeB * xB <= weeklyTime;
constraint ratioB * xA <= ratioA * xB;

% Objective
solve maximize profitA * xA + profitB * xB;
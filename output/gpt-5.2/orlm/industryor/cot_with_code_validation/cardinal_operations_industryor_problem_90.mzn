% Parameters
int: profitA = 3;
int: profitB = 5;

int: timeA = 12;          % minutes per unit of A
int: timeB = 25;          % minutes per unit of B
int: availableTime = 30 * 60;  % 30 hours in minutes

% Variables
var 0..availableTime div timeA: xA;  % units of product A
var 0..availableTime div timeB: xB;  % units of product B

% Constraints
constraint
  timeA * xA + timeB * xB <= availableTime;

constraint
  5 * xB >= 2 * xA;

% Objective
solve maximize profitA * xA + profitB * xB;
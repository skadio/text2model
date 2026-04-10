% Parameters (with values embedded)
int: profitA = 3;
int: profitB = 5;

int: timeA = 12;          % minutes per unit of A
int: timeB = 25;          % minutes per unit of B
int: availableHours = 30; % hours per week
int: availableMinutes = availableHours * 60;

% Variables
var 0..(availableMinutes div timeA): xA; % units of product A
var 0..(availableMinutes div timeB): xB; % units of product B

% Constraints
constraint timeA * xA + timeB * xB <= availableMinutes;

% For every five units of A, at least two units of B:
% xB >= (2/5)*xA  <=>  5*xB >= 2*xA
constraint 5 * xB >= 2 * xA;

% Objective
solve maximize profitA * xA + profitB * xB;
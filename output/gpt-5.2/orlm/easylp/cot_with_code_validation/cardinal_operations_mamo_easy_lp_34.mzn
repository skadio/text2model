% Parameters
int: total_fund = 10000;
int: min_X = 2000;
int: min_Y = 3000;
float: return_X = 0.05;
float: return_Y = 0.08;

% Variables
var min_X..(total_fund - min_Y): x;
var min_Y..(total_fund - min_X): y;
var float: total_return;

% Constraints
constraint x + y = total_fund;

constraint total_return = return_X * int2float(x) + return_Y * int2float(y);

% Objective
solve minimize total_return;
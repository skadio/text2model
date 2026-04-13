% Parameters
int: B = 3000;            % total budget
float: rC = 0.07;         % return rate for clothing
float: rT = 0.10;         % return rate for tech
int: techMax = 500;       % maximum investment in tech
int: ratio = 4;           % clothing must be at least ratio times tech

% Variables
var 0..B: C;              % investment in clothing
var 0..B: T;              % investment in tech
var float: profit;

% Constraints
constraint C + T <= B;
constraint C >= ratio * T;
constraint T <= techMax;

constraint profit = rC * int2float(C) + rT * int2float(T);

% Objective
solve maximize profit;
% Parameters
int: profitA = 10;
int: profitB = 20;

int: mangoStock = 25;
int: pineappleStock = 10;
int: strawberryStock = 120;

% resource use per unit (scaled to avoid fractions)
% scale factor = 8 (LCM of 4,8,2,4)
int: scale = 8;

int: mangoA = 2;        % (1/4)*8
int: mangoB = 4;        % (1/2)*8
int: mangoTotal = mangoStock * scale;

int: pineappleA = 1;    % (1/8)*8
int: pineappleB = 2;    % (1/4)*8
int: pineappleTotal = pineappleStock * scale;

int: strawA = 3;
int: strawB = 1;
int: strawTotal = strawberryStock;

int: tol = 5;           % at most 5 units left or 5 additional units used

% Variables
var 0..strawTotal: xA;
var 0..strawTotal: xB;

var -tol..tol: mangoDiff;
var -tol..tol: pineappleDiff;
var -tol..tol: strawDiff;

% Constraints
constraint mangoA * xA + mangoB * xB - mangoTotal = mangoDiff;
constraint pineappleA * xA + pineappleB * xB - pineappleTotal = pineappleDiff;
constraint strawA * xA + strawB * xB - strawTotal = strawDiff;

% Objective
solve maximize profitA * xA + profitB * xB;
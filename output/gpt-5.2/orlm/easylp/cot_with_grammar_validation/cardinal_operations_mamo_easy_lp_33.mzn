% Parameters
int: minX = 5000;
int: minY = 2000;
int: maxTotal = 10000;
int: minInterestDollars = 700;

% Use integer basis points (1 bp = 0.01%) to avoid floating point:
% interest: 7% = 7000 bp, 8% = 8000 bp, so interest constraint:
% 7000*X + 8000*Y >= 700 * 100000
int: bpScale = 100000;
int: rX_bp = 7000;
int: rY_bp = 8000;

% Transaction costs in cents per dollar to keep objective integral:
% 0.01 $/dollar = 1 cent/dollar, 0.02 $/dollar = 2 cents/dollar
int: cX_cents_per_dollar = 1;
int: cY_cents_per_dollar = 2;

% Variables
var minX..maxTotal: X;
var minY..maxTotal: Y;

var 0..(cX_cents_per_dollar*maxTotal + cY_cents_per_dollar*maxTotal): totalCostCents;

% Constraints
constraint X + Y <= maxTotal;

constraint rX_bp * X + rY_bp * Y >= minInterestDollars * bpScale;

constraint totalCostCents = cX_cents_per_dollar * X + cY_cents_per_dollar * Y;

% Objective
solve minimize totalCostCents;
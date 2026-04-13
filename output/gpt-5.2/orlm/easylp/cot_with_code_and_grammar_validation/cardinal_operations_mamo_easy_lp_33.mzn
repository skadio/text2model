% Parameters
int: minX = 5000;
int: minY = 2000;
int: maxTotal = 10000;

int: reqIncomeCents = 70000;          % $700.00 in cents
int: yieldX_perDollar_cents = 7;      % 7% = 0.07 dollars per dollar = 7 cents per dollar
int: yieldY_perDollar_cents = 8;      % 8% = 0.08 dollars per dollar = 8 cents per dollar

int: costX_perDollar_cents = 1;       % $0.01 per dollar = 1 cent per dollar
int: costY_perDollar_cents = 2;       % $0.02 per dollar = 2 cents per dollar

% Variables
var minX..maxTotal: X;
var minY..maxTotal: Y;
var 0..(costX_perDollar_cents*maxTotal + costY_perDollar_cents*maxTotal): totalCostCents;

% Constraints
constraint X + Y <= maxTotal;

constraint yieldX_perDollar_cents * X + yieldY_perDollar_cents * Y >= reqIncomeCents;

constraint totalCostCents = costX_perDollar_cents * X + costY_perDollar_cents * Y;

% Objective
solve minimize totalCostCents;
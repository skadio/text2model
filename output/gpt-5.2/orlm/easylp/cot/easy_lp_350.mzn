% Parameters (with values embedded)
int: U1 = 100;
int: U2 = 80;
int: U3 = 60;
int: U4 = 50;

int: C12_max = 100;
int: C23_min = 50;
int: D34_max = 30;
int: Strat_min = 150;

% Costs as exact rationals (tenths) to avoid floating-point issues:
% 0.5=5/10, 0.2=2/10, 0.3=3/10, 0.4=4/10
int: costScale = 10;
int: c1 = 5;
int: c2 = 2;
int: c3 = 3;
int: c4 = 4;

% Variables
var 0..U1: X1;
var 0..U2: X2;
var 0..U3: X3;
var 0..U4: X4;

% Total cost in scaled units (tenths)
var 0..(c1*U1 + c2*U2 + c3*U3 + c4*U4): totalCostScaled;

% Constraints
constraint X1 + X2 <= C12_max;
constraint X2 + X3 >= C23_min;
constraint X3 - X4 <= D34_max;
constraint 10*X1 + 15*X2 - 5*X3 - 20*X4 >= Strat_min;

constraint totalCostScaled = c1*X1 + c2*X2 + c3*X3 + c4*X4;

% Objective
solve minimize totalCostScaled;
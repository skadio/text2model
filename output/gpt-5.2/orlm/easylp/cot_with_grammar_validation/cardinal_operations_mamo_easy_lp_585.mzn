% Parameters
int: n = 4;
set of int: CH = 1..n;

int: TV = 1;
int: Radio = 2;
int: Social = 3;
int: Outdoor = 4;

array[CH] of int: maxAlloc = [700, 600, 500, 400];

% Costs per unit (scaled by 10 to keep integer objective):
% TV 0.5 -> 5, Radio 0.6 -> 6, Social 0.8 -> 8, Outdoor 1.2 -> 12
array[CH] of int: cost10 = [5, 6, 8, 12];

% Variables
array[CH] of var 0..700: x;  % budgets (whole numbers), upper bounds tightened by constraints below

var int: totalCost10;  % total cost scaled by 10

% Constraints
constraint forall(c in CH) (x[c] <= maxAlloc[c]);

constraint x[TV] + x[Radio] >= 500;

constraint abs(x[Social] - x[Radio]) <= 200;

constraint x[Outdoor] >= x[TV] + 100;

constraint x[Social] + x[Outdoor] <= 800;

constraint totalCost10 = sum(c in CH)(cost10[c] * x[c]);

% Objective
solve minimize totalCost10;
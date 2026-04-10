% Parameters
int: total_area = 120;

set of int: F = 1..4; % 1=apples, 2=pears, 3=oranges, 4=lemons
array[F] of int: profit = [2000, 1800, 2200, 3000];

int: A = 1;
int: P = 2;
int: O = 3;
int: L = 4;

% Variables
array[F] of var 0..total_area: acres;
array[F] of var bool: grow;

var 0..(total_area * max(profit)): total_profit;

% Constraints
constraint sum(f in F)(acres[f]) <= total_area;

constraint acres[A] >= 2 * acres[P];
constraint acres[A] >= 3 * acres[L];
constraint acres[O] = 2 * acres[L];

constraint forall(f in F)(
  acres[f] <= total_area * bool2int(grow[f])
);

constraint sum(f in F)(bool2int(grow[f])) <= 2;

% Objective
constraint total_profit = sum(f in F)(profit[f] * acres[f]);
solve maximize total_profit;
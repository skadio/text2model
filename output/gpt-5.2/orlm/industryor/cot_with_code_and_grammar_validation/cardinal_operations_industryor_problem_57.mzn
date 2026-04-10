% Parameters
int: total_area = 120;

set of int: FRUITS = 1..4;
int: APPLES = 1;
int: PEARS = 2;
int: ORANGES = 3;
int: LEMONS = 4;

array[FRUITS] of int: profit = [2000, 1800, 2200, 3000];

% Variables
array[FRUITS] of var 0..total_area: acres;
array[FRUITS] of var bool: grow;

% Constraints
constraint sum(f in FRUITS)(acres[f]) <= total_area;

constraint acres[APPLES] >= 2 * acres[PEARS];
constraint acres[APPLES] >= 3 * acres[LEMONS];
constraint acres[ORANGES] = 2 * acres[LEMONS];

constraint sum(f in FRUITS)(bool2int(grow[f])) <= 2;

constraint forall(f in FRUITS) (
  acres[f] <= total_area * bool2int(grow[f])
);

% Objective
solve maximize sum(f in FRUITS)(profit[f] * acres[f]);
% Parameters (with values embedded)
int: P = 2;
set of int: PROD = 1..P;
int: LIQ = 1;
int: SOL = 2;

array[PROD] of int: inv0 = [30, 90];          % beginning inventory (lots)
array[PROD] of int: demand = [75, 95];        % forecast demand (lots)

int: M = 2;
set of int: MACH = 1..M;
int: M1 = 1;
int: M2 = 2;

% processing time (minutes per lot): time[machine, product]
array[MACH, PROD] of int: time_min = array2d(MACH, PROD,
  [ 50, 24,   % Machine 1: liquid, solid
    30, 33    % Machine 2: liquid, solid
  ]);

% available time (minutes)
array[MACH] of int: avail_min = [40*60, 35*60];

% Variables
array[PROD] of var float: x;        % production (lots), fractional allowed
array[PROD] of var float: inv_end;  % ending inventory (lots)

% Constraints
constraint forall(p in PROD) (x[p] >= 0.0);
constraint forall(p in PROD) (inv_end[p] >= 0.0);

% Inventory balance: ending inventory = beginning + production - demand
constraint forall(p in PROD) (
  inv_end[p] = inv0[p] + x[p] - demand[p]
);

% Machine capacity constraints (minutes)
constraint forall(m in MACH) (
  sum(p in PROD) ( time_min[m,p] * x[p] ) <= avail_min[m]
);

% Objective
solve maximize sum(p in PROD) (inv_end[p]);
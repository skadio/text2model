% Fertilizer production planning (LP with fractional lots)

% Sets
int: nProd = 2;
set of int: P = 1..nProd;
int: nMach = 2;
set of int: M = 1..nMach;

% Product indices
int: LIQ = 1;
int: SOL = 2;

% Processing time (minutes per lot)
array[M, P] of int: time_min = array2d(M, P,
  [ 50, 24,   % Machine 1: liquid, solid
    30, 33    % Machine 2: liquid, solid
  ]);

% Data
array[P] of float: init_inv = [30.0, 90.0];
array[P] of float: demand   = [75.0, 95.0];

array[M] of int: avail_hours = [40, 35];
array[M] of int: avail_min = [avail_hours[m] * 60 | m in M];

% Variable bounds
float: UB = 10000.0;

% Decision variables (lots; can be fractional)
array[P] of var 0.0..UB: prod;
array[P] of var 0.0..UB: end_inv;

% Machine capacity constraints (minutes)
constraint
  forall(m in M) (
    sum(p in P) ( float(time_min[m,p]) * prod[p] ) <= float(avail_min[m])
  );

% Inventory balance and nonnegativity of ending inventory
constraint
  forall(p in P) (
    end_inv[p] = init_inv[p] + prod[p] - demand[p]
  );

% Objective: maximize total ending inventory
solve maximize sum(p in P) (end_inv[p]);
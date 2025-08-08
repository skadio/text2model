include "globals.mzn";

% ---------- Data ----------
int: N;                               % number of months
array[1..N] of int: demand;           % demand in each month
int: MaxRegularAmount;                % max units that can be produced normally
float: CostRegular;                   % cost per unit for normal production
float: CostOvertime;                  % cost per unit for overtime production
float: StoreCost;                     % cost per unit for storing one month

% ---------- Variables ----------
array[1..N] of var 0..MaxRegularAmount: reg;      % normal production
array[1..N] of var 0..maxint: over;                % overtime production
array[0..N] of var 0..maxint: inv;                 % inventory carried over

% ---------- Constraints ----------
constraint inv[0] = 0;
constraint forall(i in 1..N) (
  inv[i-1] + reg[i] + over[i] == demand[i] + inv[i]
);
constraint forall(i in 1..N) ( inv[i] >= 0 );

% ---------- Objective ----------
solve minimize sum(i in 1..N) (
  reg[i] * CostRegular + over[i] * CostOvertime + inv[i] * StoreCost
);

% ---------- Output ----------
output [
  "Month |  Regular |  Overtime | Inventory\n",
  concat([ show(i) ++ " |  " ++ show(reg[i]) ++ " |  " ++ show(over[i]) ++ " |  " ++ show(inv[i]) ++ "\n"
          | i in 1..N ])
];
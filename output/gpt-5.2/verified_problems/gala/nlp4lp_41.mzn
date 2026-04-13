% Production planning with regular + overtime production and inventory
% Data is provided in a .dzn file.

int: N;                              % number of months (as given)
array[1..N] of float: Demand;        % demand in each month (must be met)
float: MaxRegularAmount;             % max regular production per month
float: CostRegular;                  % $/unit regular
float: CostOvertime;                 % $/unit overtime
float: StoreCost;                    % $/unit/month holding cost

% ---- Modeling choices ----
% Use integer units; scale all float data to integers.
% (If your data is already integral, scale=1 is fine.)
int: scale = 100;

array[1..N] of int: dem = [ round(Demand[t] * scale) | t in 1..N ];
int: maxReg = round(MaxRegularAmount * scale);

int: cReg   = round(CostRegular * scale);
int: cOT    = round(CostOvertime * scale);
int: cStore = round(StoreCost * scale);

int: totalDem = sum(t in 1..N)(dem[t]);

% Decision variables (in scaled units)
array[1..N] of var 0..maxReg: regProd;
array[1..N] of var 0..totalDem: otProd;
array[0..N] of var 0..totalDem: inv;          % inventory at end of month t; inv[0]=initial

constraint inv[0] = 0;

% Inventory balance: inv[t] = inv[t-1] + production - demand (no shortages => inv[t] >= 0)
constraint forall(t in 1..N)(
  inv[t] = inv[t-1] + regProd[t] + otProd[t] - dem[t]
);

% (Optional but typical) end with no leftover inventory
constraint inv[N] = 0;

% Objective (in scaled cents^2 units; output rescales to dollars)
var int: totalCost =
  sum(t in 1..N)( cReg * regProd[t] + cOT * otProd[t] ) +
  sum(t in 1..N)( cStore * inv[t] );

solve minimize totalCost;

output [
  "Regular production (units) = ", show([ fix(regProd[t]) / scale | t in 1..N ]), "\n",
  "Overtime production (units) = ", show([ fix(otProd[t]) / scale | t in 1..N ]), "\n",
  "Inventory end of month (units) = ", show([ fix(inv[t]) / scale | t in 1..N ]), "\n",
  "Total cost ($) = ", show(fix(totalCost) / (scale * scale)), "\n"
];
% Gift basket production planning with regular & overtime labor and inventory
% Maximize profit over W weeks with given weekly demand.
% Data is provided via .dzn.

% No globals needed.

int: W;

% Costs/revenues (assumed nonnegative)
int: RegularCost;     % cost per labor hour
int: OvertimeCost;    % cost per labor hour
int: MaterialCost;    % cost per basket
int: SellingPrice;    % revenue per basket sold
int: HoldingCost;     % holding cost per basket per week (for inventory carried to next week)
int: SalvageValue;    % salvage value per basket remaining at end of season

% Time per basket. Use rational to avoid floating point.
float: AssemblyTime;

array[1..W] of int: Demand;
array[1..W] of int: RegularLabor;   % available regular labor hours in week w
array[1..W] of int: OvertimeLabor;  % available overtime labor hours in week w

% Bounds for production/inventory based on total possible production
int: maxProd =
  ceil( sum(w in 1..W)(RegularLabor[w] + OvertimeLabor[w]) / AssemblyTime );

int: maxInv = maxProd;

% Decision variables
array[1..W] of var 0..RegularLabor[w]: regHours;    % regular hours used
array[1..W] of var 0..OvertimeLabor[w]: otHours;    % overtime hours used

array[1..W] of var 0..maxProd: make;               % baskets assembled in week w
array[1..W] of var 0..maxInv: inv;                 % inventory at end of week w
array[1..W] of var 0..maxProd: sold;               % baskets sold in week w

% Initial inventory is zero (no baskets at start of week 1)
constraint inv[1] = make[1] - sold[1];
constraint sold[1] = Demand[1]; % must meet demand exactly

% Flow balance and demand satisfaction for weeks 2..W
constraint forall(w in 2..W) (
  inv[w] = inv[w-1] + make[w] - sold[w]
);
constraint forall(w in 2..W) (
  sold[w] = Demand[w]
);

% Ensure enough supply each week (implied by inv>=0 and sold=Demand, but stated for clarity)
constraint forall(w in 1..W) (
  (if w = 1 then 0 else inv[w-1] endif) + make[w] >= Demand[w]
);

% Capacity: labor hours used cannot exceed availability (already in var domains)
% Production limited by labor used and assembly time:
% make[w] <= floor((regHours[w] + otHours[w]) / AssemblyTime)
% Implement via linear inequality without division:
constraint forall(w in 1..W) (
  AssemblyTime * int2float(make[w]) <= int2float(regHours[w] + otHours[w])
);

% Objective: maximize profit
% Revenue from sold baskets + salvage of ending inventory
% minus material costs, labor costs, holding costs (for inv carried after each week except last)
var int: profit =
  sum(w in 1..W)( SellingPrice * sold[w]
                - MaterialCost * make[w]
                - RegularCost * regHours[w]
                - OvertimeCost * otHours[w]
                )
  - sum(w in 1..W-1)( HoldingCost * inv[w] )
  + SalvageValue * inv[W];

solve maximize profit;

output [
  "profit = ", show(profit), "\n",
  "regHours = ", show(regHours), "\n",
  "otHours  = ", show(otHours), "\n",
  "make     = ", show(make), "\n",
  "sold     = ", show(sold), "\n",
  "inv      = ", show(inv), "\n"
];
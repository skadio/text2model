% Gift basket production planning (profit maximization)

%-----------------------
% Parameters
%-----------------------
int: W;
set of int: Weeks = 1..W;

float: RegularCost;
float: OvertimeCost;
float: AssemblyTime;
float: MaterialCost;
float: SellingPrice;
float: HoldingCost;
float: SalvageValue;

array[Weeks] of int: Demand;
array[Weeks] of int: RegularLabor;    % available regular hours per week
array[Weeks] of int: OvertimeLabor;   % available overtime hours per week

%-----------------------
% Decision variables
%-----------------------
array[Weeks] of var 0..max(RegularLabor): RegHours;
array[Weeks] of var 0..max(OvertimeLabor): OTHours;

array[Weeks] of var 0..sum(Demand): Produce;  % baskets produced in week w
array[Weeks] of var 0..sum(Demand): Sold;     % baskets sold in week w (must meet demand)
array[Weeks] of var 0..sum(Demand): Inv;      % end-of-week inventory

%-----------------------
% Constraints
%-----------------------
constraint forall(w in Weeks) (
  RegHours[w] <= RegularLabor[w]
);

constraint forall(w in Weeks) (
  OTHours[w] <= OvertimeLabor[w]
);

% Production limited by total labor time available
constraint forall(w in Weeks) (
  AssemblyTime * int2float(Produce[w]) <= int2float(RegHours[w] + OTHours[w])
);

% Demand must be met each week
constraint forall(w in Weeks) (
  Sold[w] = Demand[w]
);

% Inventory flow, with no initial inventory
constraint Sold[1] <= Produce[1];
constraint Inv[1] = Produce[1] - Sold[1];

constraint forall(w in 2..W) (
  Sold[w] <= Inv[w-1] + Produce[w]
);

constraint forall(w in 2..W) (
  Inv[w] = Inv[w-1] + Produce[w] - Sold[w]
);

%-----------------------
% Objective: maximize profit over the season
%-----------------------
solve maximize
  sum(w in Weeks) (SellingPrice * int2float(Sold[w]))
- sum(w in Weeks) (MaterialCost * int2float(Produce[w]))
- sum(w in Weeks) (RegularCost * int2float(RegHours[w]) + OvertimeCost * int2float(OTHours[w]))
- sum(w in 1..W-1) (HoldingCost * int2float(Inv[w]))
+ SalvageValue * int2float(Inv[W]);

%-----------------------
% Output
%-----------------------
output [
  "RegHours = ", show(RegHours), "\n",
  "OTHours  = ", show(OTHours), "\n",
  "Produce  = ", show(Produce), "\n",
  "Inv      = ", show(Inv), "\n"
];
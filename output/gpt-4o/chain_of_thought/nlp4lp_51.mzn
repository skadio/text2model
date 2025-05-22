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
array[Weeks] of int: RegularLabor;
array[Weeks] of int: OvertimeLabor;

array[Weeks] of var int: Produced;          % baskets assembled in week w
array[Weeks] of var float: RegUsed;         % regular labour hours used in week w
array[Weeks] of var float: OverUsed;        % overtime labour hours used in week w
array[0..W] of var int: Inventory;          % end-of-week inventory (Inventory[0] = 0)

% Initial inventory
constraint Inventory[0] = 0;

% Labour-capacity limits
constraint
  forall(w in Weeks)(
    0.0 <= RegUsed[w] /\ RegUsed[w] <= int2float(RegularLabor[w])
  );
constraint
  forall(w in Weeks)(
    0.0 <= OverUsed[w] /\ OverUsed[w] <= int2float(OvertimeLabor[w])
  );

% Production requires labour
constraint
  forall(w in Weeks)(
    RegUsed[w] + OverUsed[w] = AssemblyTime * int2float(Produced[w])
  );

% Inventory balance and non-negativity
constraint
  forall(w in Weeks)(
    Inventory[w] = Inventory[w-1] + Produced[w] - Demand[w] /\
    Inventory[w] >= 0
  );

% Objective: maximise total profit over the season
solve maximize
      sum(w in Weeks)(SellingPrice * int2float(Demand[w]))          % revenue (fixed)
    + SalvageValue * int2float(Inventory[W])                        % salvage value
    - sum(w in Weeks)(                                              % costs
          RegularCost  * RegUsed[w] +
          OvertimeCost * OverUsed[w] +
          MaterialCost * int2float(Produced[w]) +
          HoldingCost  * int2float(Inventory[w-1])
      );
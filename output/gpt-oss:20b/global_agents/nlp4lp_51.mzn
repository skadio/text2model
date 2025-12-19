include "globals.mzn";

/*  Parameters (provided in the .dzn file) */
int: W;                               % number of weeks
int: RegularCost;                     % cost of regular labour per hour
int: OvertimeCost;                    % cost of overtime labour per hour
float: AssemblyTime;                  % time to assemble one basket
int: MaterialCost;                    % material cost per basket
int: SellingPrice;                    % selling price per basket
int: HoldingCost;                     % holding cost per basket per week
int: SalvageValue;                    % salvage value of a basket at season end

array[1..W] of int: Demand;          % demand each week
array[1..W] of int: RegularLabor;    % regular labour available each week
array[1..W] of int: OvertimeLabor;   % overtime labour available each week


/*  Decision variables */
array[1..W] of var int: P;               % baskets produced each week
array[1..W] of var float: RegHours;      % regular labour hours used each week
array[1..W] of var float: OvrHours;      % overtime labour hours used each week
array[1..W+1] of var int: I;            % inventory after week w (I[1] = 0)


/*  Constraints */

/* Labour utilisation and availability */
constraint forall(w in 1..W)(
    P[w] >= 0
    /\ RegHours[w] >= 0
    /\ OvrHours[w] >= 0
    /\ RegHours[w] <= float(RegularLabor[w])
    /\ OvrHours[w] <= float(OvertimeLabor[w])
    /\ RegHours[w] + OvrHours[w] = P[w] * AssemblyTime
);

/* Inventory balance – demand must be satisfied */
constraint I[1] = 0;
constraint forall(w in 1..W)(
    I[w+1] = I[w] + P[w] - Demand[w]
    /\ I[w+1] >= 0
);


/*  Objective – maximise profit */
var float: profit = sum(w in 1..W) (Demand[w] * SellingPrice)
                    - sum(w in 1..W) (RegHours[w] * RegularCost
                                      + OvrHours[w] * OvertimeCost
                                      + P[w] * MaterialCost)
                    - sum(w in 1..W) (I[w+1] * HoldingCost)
                    + I[W+1] * SalvageValue;

solve maximize profit;


/*  Output */
output [
    "Profit = ", show(profit), "\n",
    "Week | Production | RegHours | OvrHours | InventoryAfter\n"
] ++
    [ show(w), " | ", show(P[w]), " | ", show(RegHours[w]), " | ", show(OvrHours[w]), " | ", show(I[w+1]), "\n" | w in 1..W ];
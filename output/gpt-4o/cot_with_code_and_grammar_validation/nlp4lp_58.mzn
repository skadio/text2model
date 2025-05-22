% Parameters
int: M;
int: P;

set of int: Machines = 1..M;
set of int: Parts    = 1..P;

array[Machines, Parts] of int: TimeRequired;
array[Machines] of int: MachineCosts;
array[Machines] of int: Availability;
array[Parts]    of int: Prices;
array[Parts]    of int: MinBatches;

int: StandardCost;
int: OvertimeCost;
int: OvertimeHour;
int: MinProfit;

% Large constant
int: BIG = 1000000;

% Upper bounds for batches based on machines 2..M
array[Parts] of int: BatchUB =
[
   min( ([ Availability[m] div TimeRequired[m,p] | m in Machines where m > 1 /\ TimeRequired[m,p] > 0 ] ) ++ [BIG] )
   | p in Parts
];

% Decision variables
array[Parts]    of var int: Batches;
array[Machines] of var int: Hours;

var 0..Availability[1] : RegularHours1;
var 0..OvertimeHour    : OvertimeHours1;

% Auxiliary variables
var int: Revenue     = sum(p in Parts)(Prices[p] * Batches[p]);
var int: LaborCost1  = StandardCost * RegularHours1 + OvertimeCost * OvertimeHours1;
var int: OtherCosts  = sum(m in Machines where m > 1)(MachineCosts[m] * Hours[m]);
var int: TotalCost   = LaborCost1 + OtherCosts;
var int: Profit      = Revenue - TotalCost;

% Constraints
constraint
   forall(p in Parts)(
      Batches[p] >= MinBatches[p] /\ Batches[p] <= BatchUB[p]
   );

constraint
   forall(m in Machines)(
      Hours[m] = sum(p in Parts)(TimeRequired[m,p] * Batches[p])
   );

constraint
   RegularHours1 + OvertimeHours1 = Hours[1];

constraint
   forall(m in Machines where m > 1)(
      0 <= Hours[m] /\ Hours[m] <= Availability[m]
   );

constraint
   Profit >= MinProfit;

% Objective
solve maximize Profit;
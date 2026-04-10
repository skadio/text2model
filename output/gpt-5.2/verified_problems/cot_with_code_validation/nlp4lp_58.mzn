% Auto parts production planning with outsourced machine 1 labor (standard + overtime)

% --------------------
% Parameters (from .dzn)
% --------------------
int: M;
int: P;

array[1..M, 1..P] of int: TimeRequired;
array[1..M] of int: MachineCosts;
array[1..M] of int: Availability;

array[1..P] of int: Prices;
array[1..P] of int: MinBatches;

int: StandardCost;
int: OvertimeCost;
int: OvertimeHour;
int: MinProfit;

% --------------------
% Decision variables
% --------------------
% Use a safe upper bound derived from machines 2..M availabilities.
% (Machine 1 has no availability limit; only overtime is limited.)
int: maxBatches =
  if M >= 2 then
    max(0,
        max(p in 1..P)(
          max(m in 2..M)(
            if TimeRequired[m,p] > 0 then Availability[m] div TimeRequired[m,p] else 0 endif
          )
        )
    )
  else
    100000
  endif;

array[1..P] of var 0..maxBatches: Batches;

% Machine 1 labor split
var 0..sum(p in 1..P)(TimeRequired[1,p] * maxBatches): StdHours1;
var 0..OvertimeHour: OtHours1;

% Accounting
var int: Revenue;
var int: MachineCostOther;
var int: LaborCost1;
var int: Profit;

% --------------------
% Constraints
% --------------------
constraint forall(p in 1..P) (Batches[p] >= MinBatches[p]);

% Machine availability for machines 2..M
constraint
  if M >= 2 then
    forall(m in 2..M)(
      sum(p in 1..P)(TimeRequired[m,p] * Batches[p]) <= Availability[m]
    )
  else
    true
  endif;

% Outsourced machine 1 labor: standard hours capped by OvertimeHour; rest is overtime
constraint StdHours1 + OtHours1 = sum(p in 1..P)(TimeRequired[1,p] * Batches[p]);
constraint StdHours1 <= OvertimeHour;

% Accounting relations
constraint Revenue = sum(p in 1..P)(Prices[p] * Batches[p]);

constraint MachineCostOther =
  if M >= 2 then
    sum(m in 2..M, p in 1..P)(MachineCosts[m] * TimeRequired[m,p] * Batches[p])
  else
    0
  endif;

constraint LaborCost1 = StandardCost * StdHours1 + OvertimeCost * OtHours1;

constraint Profit = Revenue - MachineCostOther - LaborCost1;

constraint Profit >= MinProfit;

% --------------------
% Objective
% --------------------
solve maximize Profit;
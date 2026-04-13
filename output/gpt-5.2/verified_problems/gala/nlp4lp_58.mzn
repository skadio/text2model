include "globals.mzn";

/************ Data ************/
int: M;                                % number of machines
int: P;                                % number of parts
array[1..M, 1..P] of int: TimeRequired; % hours per batch (100 units) on machine m for part p
array[1..M] of int: MachineCosts;       % cost per hour for machine m (for m>=2 directly used)
array[1..M] of int: Availability;       % available hours per month for machine m (m=1 ignored)
array[1..P] of int: Prices;             % revenue per batch for part p
array[1..P] of int: MinBatches;         % minimum batches to produce for part p

int: StandardCost;                      % labor cost per hour up to standard limit (machine 1)
int: OvertimeCost;                      % labor cost per hour beyond standard limit (machine 1)
int: OvertimeHour;                      % maximum overtime hours available for machine 1
int: MinProfit;                         % desired minimum profit

/************ Decision variables ************/
% batches of each part produced per month
array[1..P] of var int: batches;

% hours used on each machine
array[1..M] of var int: hoursUsed;

% machine 1 labor split into standard + overtime
var int: stdHours1;
var int: otHours1;

/************ Basic domains (derived safe upper bound) ************/
% Upper bound from machine capacities 2..M (machine 1 availability disregarded)
int: BIG =
  let {
    array[1..P] of int: maxPerPart =
      [ if exists(m in 2..M)(TimeRequired[m,p] > 0) then
          min([ Availability[m] div TimeRequired[m,p] | m in 2..M where TimeRequired[m,p] > 0 ])
        else 0
        endif
      | p in 1..P
      ]
  } in
    sum(p in 1..P)(maxPerPart[p]) + sum(p in 1..P)(MinBatches[p]) + 1000;

constraint forall(p in 1..P)(
  batches[p] >= MinBatches[p] /\ batches[p] <= BIG
);

% hours used definition
constraint forall(m in 1..M)(
  hoursUsed[m] = sum(p in 1..P)(TimeRequired[m,p] * batches[p])
);

/************ Machine availability constraints ************/
% Machine 1 availability ignored; instead, bound overtime hours and split hours
constraint stdHours1 >= 0 /\ otHours1 >= 0;
constraint stdHours1 <= Availability[1];
constraint otHours1 <= OvertimeHour;
constraint stdHours1 + otHours1 = hoursUsed[1];

% Machines 2..M have hard availability
constraint forall(m in 2..M)(
  hoursUsed[m] <= Availability[m]
);

/************ Profit ************/
var int: revenue = sum(p in 1..P)(Prices[p] * batches[p]);

% Costs: machine 1 uses labor (piecewise), machines 2..M use MachineCosts
var int: costMachine = sum(m in 2..M)(MachineCosts[m] * hoursUsed[m]);
var int: costLabor1  = StandardCost * stdHours1 + OvertimeCost * otHours1;

var int: profit = revenue - costMachine - costLabor1;

constraint profit >= MinProfit;

/************ Objective ************/
solve maximize profit;

/************ Output ************/
output [
  "batches = ", show(batches), "\n",
  "hoursUsed = ", show(hoursUsed), "\n",
  "stdHours1 = ", show(stdHours1), "\n",
  "otHours1 = ", show(otHours1), "\n",
  "revenue = ", show(revenue), "\n",
  "costMachine = ", show(costMachine), "\n",
  "costLabor1 = ", show(costLabor1), "\n",
  "profit = ", show(profit), "\n"
];
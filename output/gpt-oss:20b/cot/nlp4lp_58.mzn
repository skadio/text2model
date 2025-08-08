% Parameters
M: int;
P: int;
TimeRequired: array[1..M, 1..P] of int;
MachineCosts: array[1..M] of int;
Availability: array[1..M] of int;
Prices: array[1..P] of int;
MinBatches: array[1..P] of int;
StandardCost: int;
OvertimeCost: int;
OvertimeHour: int;
MinProfit: int;

% Variables
var int: Batches[1..P] >= 0;

% Constraints
constraint forall(p in 1..P) (
    Batches[p] >= MinBatches[p]
);

constraint forall(m in 2..M) (
    sum(p in 1..P) Batches[p] * TimeRequired[m,p] <= Availability[m]
);

let {
    var int: hours1 = sum(p in 1..P) Batches[p] * TimeRequired[1,p];
    var int: cost1 = min(hours1, OvertimeHour) * StandardCost + max(0, hours1 - OvertimeHour) * OvertimeCost;
    var int: revenue = sum(p in 1..P) Batches[p] * Prices[p];
    var int: cost_machines = sum(m in 2..M) sum(p in 1..P) Batches[p] * TimeRequired[m,p] * MachineCosts[m];
    var int: totalCost = cost_machines + cost1;
    var int: profit = revenue - totalCost;
} in
    profit >= MinProfit;

% Objective
solve satisfy;
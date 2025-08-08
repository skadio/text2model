include "globals.mzn";

int: M; % Number of machines
int: P; % Number of parts

array[1..M, 1..P] of int: TimeRequired; % Time required to produce a batch of part p on machine m
array[1..M] of int: MachineCosts; % Cost associated with running machine m
array[1..M] of int: Availability; % Availability of machine m for production each month
array[1..P] of int: Prices; % Price obtained from selling a batch of part p
array[1..P] of int: MinBatches; % Minimum number of batches of part p that should be produced
array[1..M] of int: ExtraCosts; % Extra cost incurred when running machine m beyond regular operation
array[1..M] of int: MaxExtra; % Maximum extra hours machine m can be run

% Variables
array[1..P] of var 0..max_int: batches; % Number of batches to produce for each part
array[1..M] of var 0..max_int: extra_hours; % Extra hours purchased for each machine

% Calculate total production time for each machine
array[1..M] of var 0..max_int: total_time;
constraint forall(m in 1..M)(
    total_time[m] = sum(p in 1..P)(TimeRequired[m, p] * batches[p]) + extra_hours[m]
);

% Profit calculation
var int: profit = sum(p in 1..P)(Prices[p] * batches[p]) - sum(m in 1..M)(MachineCosts[m] * total_time[m]) - sum(m in 1..M)(ExtraCosts[m] * extra_hours[m]);

% Constraints
constraint forall(m in 1..M)(
    total_time[m] <= Availability[m] + MaxExtra[m] % Total time must not exceed available time plus extra time
);

constraint forall(p in 1..P)(
    batches[p] >= MinBatches[p] % Minimum batches constraint
);

% Cumulative constraint for machine usage
array[1..M] of var 0..max_int: start; % Start times for each machine
array[1..M] of var 0..max_int: dur; % Durations for each machine
array[1..M] of int: use = [sum(p in 1..P)(TimeRequired[m, p] * batches[p]) | m in 1..M]; % Resource usage for each machine
int: cap = max(Availability) + max(MaxExtra); % Maximum availability of each machine

constraint cumulative(start, dur, use, cap);

% Solve
solve maximize profit;

% Output
output [ "Batches = ", show(batches), "\nProfit = ", show(profit), "\n" ];
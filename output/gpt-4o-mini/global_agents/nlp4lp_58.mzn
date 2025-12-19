include "globals.mzn";

int: M;  % Number of machines
int: P;  % Number of parts
array[1..M, 1..P] of int: TimeRequired;  % Time required to produce each part on each machine
array[1..M] of int: MachineCosts;         % Cost associated with each machine
array[1..M] of int: Availability;          % Availability in hours of each machine per month
array[1..P] of int: Prices;                % Price obtained from selling each part
array[1..P] of int: MinBatches;            % Minimum number of batches of each part
int: StandardCost;                         % Standard cost for a machine to run for one hour
int: OvertimeCost;                         % Overtime cost for a machine to run for one hour beyond the standard availability
int: OvertimeHour;                         % Numbers of overtime hours available for a machine
int: MinProfit;                            % The minimum profit the manufacturer wants to achieve

/* Variables */
array[1..P] of var 0..max_batches: batches;  % Batches of each part
array[1..M] of var 0..max_hours: hours;       % Total hours used on each machine
var 0..max_profit: profit;                    % Total profit

/* Constraints */
% Ensure minimum batches for each part
constraint forall(p in 1..P)(batches[p] >= MinBatches[p]);

% Calculate total hours used on each machine
constraint forall(m in 1..M)(
    hours[m] = sum(p in 1..P)(TimeRequired[m, p] * batches[p])
);

/* Calculate total cost */
var 0..max_cost: total_cost;
constraint total_cost = sum(m in 1..M)(
    if hours[m] <= Availability[m] then
        hours[m] * MachineCosts[m]
    else
        Availability[m] * MachineCosts[m] + (hours[m] - Availability[m]) * OvertimeCost
    endif
);

/* Calculate total revenue */
var 0..max_revenue: total_revenue;
constraint total_revenue = sum(p in 1..P)(Prices[p] * batches[p]);

/* Calculate profit */
constraint profit = total_revenue - total_cost;

/* Ensure profit exceeds minimum required */
constraint profit >= MinProfit;

/* Solve & output */
solve maximize profit;
output [ "Batches = ", show(batches), "\nTotal Profit = ", show(profit), "\n" ];
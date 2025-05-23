int: M;
int: P;

set of int: Machines = 1..M;
set of int: Parts    = 1..P;

array[Machines, Parts] of int: TimeRequired;   % hours per batch on machine m for part p
array[Machines]          of int: MachineCosts; % cost per machine hour on machine m
array[Machines]          of int: Availability; % total hours available on machine m
array[Parts]             of int: Prices;       % selling price per batch of part p
array[Parts]             of int: SetupTime;    % one-time setup (machine 1) if part p is produced

int: BigBound = max(Availability);             % coarse upper bound on number of batches

array[Parts]   of var 0..BigBound: Batches;    % number of 100-part batches produced
array[Parts]   of var 0..1:         Produce;   % 1 if at least one batch of part p is produced

array[Machines] of var 0..sum(Availability): HoursUsed;   % actual hours used on each machine

% Link Produce and Batches
constraint
    forall(p in Parts) (
        (Batches[p] <= Produce[p] * BigBound) /\
        (Batches[p] >= Produce[p])            % at least one batch if produced
    );

% Machine capacity and hours used
constraint
    forall(m in Machines) (
        HoursUsed[m] =
            sum(p in Parts)(TimeRequired[m,p] * Batches[p]) +
            (if m = 1 then sum(p in Parts)(SetupTime[p] * Produce[p]) else 0 endif)
    );

constraint
    forall(m in Machines) (
        HoursUsed[m] <= Availability[m]
    );

var int: TotalRevenue = sum(p in Parts)(Prices[p] * Batches[p]);
var int: TotalCost    = sum(m in Machines)(MachineCosts[m] * HoursUsed[m]);
var int: Profit       = TotalRevenue - TotalCost;

solve maximize Profit;
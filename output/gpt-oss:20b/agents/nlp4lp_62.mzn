% Production planning – maximise profit

%--------------------------------------------------------------------
%  Input data (provided by a .dzn file)
%--------------------------------------------------------------------
int: M;                                 % number of machines
int: P;                                 % number of part types

array[1..M, 1..P] of int: TimeRequired; % hours per batch on machine m for part p
array[1..M] of int: MachineCosts;        % cost per hour of operating machine m
array[1..M] of int: Availability;        % available hours per month on machine m
array[1..P] of int: Prices;              % selling price per batch of part p
array[1..P] of int: SetupTime;           % setup time on machine 1 before first batch of part p

%--------------------------------------------------------------------
%  Derived bounds
%--------------------------------------------------------------------
int: minTime =
  min([min(TimeRequired[m,p]) | m in 1..M, p in 1..P]);

int: maxAvail = max(Availability);
int: max_batches = maxAvail div minTime;   % safe upper bound for number of batches

%--------------------------------------------------------------------
%  Decision variables
%--------------------------------------------------------------------
array[1..P] of var 0..max_batches: x;   % number of batches produced for part p
array[1..P] of var bool: y;             % y[p] = 1 iff part p is produced

array[1..M] of var 0..maxAvail: hours;  % total hours used on machine m

%--------------------------------------------------------------------
%  Constraints
%--------------------------------------------------------------------
% y[p] indicates whether x[p] > 0
constraint forall(p in 1..P) (
    y[p] = (x[p] > 0)
);

% Hours used on each machine
constraint hours[1] =
    sum(p in 1..P) (TimeRequired[1,p] * x[p]) + 
    sum(p in 1..P) (SetupTime[p] * y[p]);

constraint forall(m in 2..M) (
    hours[m] = sum(p in 1..P) (TimeRequired[m,p] * x[p])
);

% Availability limits
constraint forall(m in 1..M) (
    hours[m] <= Availability[m]
);

%--------------------------------------------------------------------
%  Objective – maximise profit
%--------------------------------------------------------------------
var int: profit =
    sum(p in 1..P) (Prices[p] * x[p]) -
    sum(m in 1..M) (MachineCosts[m] * hours[m]);

solve maximize profit;

%--------------------------------------------------------------------
%  Output
%--------------------------------------------------------------------
output [
    "Profit = ", show(profit), "\n",
    "Batches per part = ", show(x), "\n",
    "Hours per machine = ", show(hours), "\n"
];
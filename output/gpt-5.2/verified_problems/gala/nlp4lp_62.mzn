include "globals.mzn";

%========================
% Input data (from .dzn)
%========================
int: M;                       % number of machines
int: P;                       % number of parts
array[1..M, 1..P] of int: TimeRequired;   % hours per batch on machine m for part p
array[1..M] of int: MachineCosts;         % cost per hour for machine m
array[1..M] of int: Availability;         % available hours per month for machine m
array[1..P] of int: Prices;               % revenue per batch of part p
array[1..P] of int: SetupTime;            % setup hours on machine 1 if part p is produced

%========================
% Decision variables
%========================
% Number of batches (of 100 parts) produced for each part
array[1..P] of var 0..max(Availability): x;

% Whether a part is produced at all (to trigger setup time on machine 1)
array[1..P] of var 0..1: y;

%========================
% Linking constraints
%========================
% If x[p] > 0 then y[p] = 1; if y[p] = 0 then x[p] = 0
constraint forall(p in 1..P)(
  x[p] <= y[p] * max(Availability)
);

%========================
% Capacity constraints
%========================
% Machine 1 includes setup time per part produced; others do not.
constraint
  sum(p in 1..P)(TimeRequired[1,p] * x[p] + SetupTime[p] * y[p]) <= Availability[1];

constraint forall(m in 2..M)(
  sum(p in 1..P)(TimeRequired[m,p] * x[p]) <= Availability[m]
);

%========================
% Objective: maximize profit
%========================
var int: revenue = sum(p in 1..P)(Prices[p] * x[p]);

var int: operating_cost =
  sum(m in 1..M)(
    MachineCosts[m] *
      ( if m = 1 then
          sum(p in 1..P)(TimeRequired[m,p] * x[p] + SetupTime[p] * y[p])
        else
          sum(p in 1..P)(TimeRequired[m,p] * x[p])
        endif )
  );

var int: profit = revenue - operating_cost;

solve maximize profit;

%========================
% Output
%========================
output [
  "Batches x = ", show(x), "\n",
  "Produced y = ", show(y), "\n",
  "Revenue = ", show(revenue), "\n",
  "OperatingCost = ", show(operating_cost), "\n",
  "Profit = ", show(profit), "\n",
  "MachineHoursUsed = [",
    concat([ if m>1 then ", " else "" endif ++
             show( if m=1 then
                     sum(p in 1..P)(TimeRequired[m,p]*x[p] + SetupTime[p]*y[p])
                   else
                     sum(p in 1..P)(TimeRequired[m,p]*x[p])
                   endif )
           | m in 1..M ]),
  "]\n"
];
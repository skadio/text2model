% Liquid products A and B production planning (LP / ILP)
% Maximize profit subject to time, demand ratio, and storage constraints.

% Data (embedded)
int: max_hours = 40;
int: profitA = 30;
int: profitB = 10;
int: hoursA  = 6;
int: hoursB  = 3;
int: storageA_max = 4;      % max kg of A storable per week
int: demand_ratio = 3;      % B >= 3*A

% Decision variables (kg produced/sold per week)
% If fractional production is allowed, change to: var float: A; var float: B;
var 0..storageA_max: A;     % kg of product A (also limited by storage)
var 0..1000: B;             % kg of product B (upper bound made safe by time)

% Constraints
constraint hoursA * A + hoursB * B <= max_hours;    % production time
constraint B >= demand_ratio * A;                   % market demand ratio
constraint A <= storageA_max;                       % storage limit for A

% Objective: maximize profit
var int: Profit = profitA * A + profitB * B;

solve maximize Profit;

output [
  "A (kg) = ", show(A), "\n",
  "B (kg) = ", show(B), "\n",
  "Profit (£) = ", show(Profit), "\n",
  "Hours used = ", show(hoursA*A + hoursB*B), " / ", show(max_hours), "\n"
];
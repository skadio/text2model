% Repairman profit maximization (integer linear program)

% Data (embedded)
int: insp_avail = 5000;      % minutes available for inspection
int: total_avail = 20000;    % minutes available overall schedule

% Washing machine parameters
int: w_insp = 30;
int: w_fix  = 90;
int: w_profit = 250;

% Freezer parameters
int: f_insp = 20;
int: f_fix  = 125;
int: f_profit = 375;

% Decision variables: number of each appliance to repair
var 0..(insp_avail div min(w_insp, f_insp)): w;  % washing machines
var 0..(insp_avail div min(w_insp, f_insp)): f;  % freezers

% Time constraints
constraint w_insp * w + f_insp * f <= insp_avail;
constraint (w_insp + w_fix) * w + (f_insp + f_fix) * f <= total_avail;

% Objective: maximize earnings
var int: profit = w_profit * w + f_profit * f;

solve maximize profit;

output [
  "WashingMachines = ", show(w), "\n",
  "Freezers = ", show(f), "\n",
  "Profit = $", show(profit), "\n",
  "InspectionUsed = ", show(w_insp*w + f_insp*f), " / ", show(insp_avail), "\n",
  "TotalTimeUsed = ", show((w_insp+w_fix)*w + (f_insp+f_fix)*f), " / ", show(total_avail), "\n"
];
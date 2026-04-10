% Linear program (continuous) reformulated to avoid float-linear limitations in Gecode
% by scaling all monetary quantities to "pence" (integer) and keeping decision variables integer
% in units of 1/100 batch (i.e., 0.01 batch resolution).

%-----------------------------
% Data (embedded)
%-----------------------------
int: machine_time_X = 13;  % minutes per batch
int: craft_time_X   = 20;
int: machine_time_Y = 19;
int: craft_time_Y   = 29;

int: machine_minutes_available = 40 * 60; % 2400
int: craft_minutes_available   = 35 * 60; % 2100

int: revenue_X_pence = 20 * 100; % £20 -> 2000 pence per batch
int: revenue_Y_pence = 30 * 100; % £30 -> 3000 pence per batch

% Costs per minute in pence:
% machine: £10/hour = 1000 pence/hour => 1000/60 pence/min
% craftsman: £2/hour = 200 pence/hour => 200/60 pence/min
% Keep integer arithmetic by multiplying everything by 60.
int: machine_cost_num = 1000; % pence per hour (numerator when divided by 60)
int: craft_cost_num   = 200;  % pence per hour (numerator when divided by 60)

int: min_batches_X = 10;

% Decision variable scaling:
% Let x = batches_X * 100, y = batches_Y * 100 (so x,y are integers, 0.01 batch granularity).
int: SCALE = 100;

%-----------------------------
% Variables
%-----------------------------
var 0..1000000: x; % scaled batches of X (x=1000 means 10.00 batches)
var 0..1000000: y; % scaled batches of Y

%-----------------------------
% Constraints
%-----------------------------
% Contract requirement: batches_X >= 10  => x >= 10*100
constraint x >= min_batches_X * SCALE;

% Resource capacities:
% machine_time_X*(x/100) + machine_time_Y*(y/100) <= machine_minutes_available
% Multiply by 100 to keep integer:
constraint machine_time_X * x + machine_time_Y * y <= machine_minutes_available * SCALE;

constraint craft_time_X * x + craft_time_Y * y <= craft_minutes_available * SCALE;

%-----------------------------
% Objective (maximize profit)
%-----------------------------
% Compute profit in "pence * 60 * SCALE" units to avoid fractions from per-minute costs.
%
% Revenue (pence): revX*x/100 + revY*y/100
% Multiply by 60*SCALE => 60*(revX*x + revY*y)
%
% Cost (pence): (machine_cost_num/60)*machine_minutes + (craft_cost_num/60)*craft_minutes
% machine_minutes = (machine_time_X*x + machine_time_Y*y)/100
% Multiply by 60*SCALE => SCALE * (machine_cost_num*machine_minutes + craft_cost_num*craft_minutes)
% => machine_cost_num*(machine_time_X*x + machine_time_Y*y) + craft_cost_num*(craft_time_X*x + craft_time_Y*y)
%
var int: profit_scaled =
    60 * (revenue_X_pence * x + revenue_Y_pence * y)
  - ( machine_cost_num * (machine_time_X * x + machine_time_Y * y)
    + craft_cost_num   * (craft_time_X   * x + craft_time_Y   * y) );

solve maximize profit_scaled;

%-----------------------------
% Output
%-----------------------------
output [
  "batches_X = ", show(x / SCALE), ".", if (x mod SCALE) < 10 then "0" else "" endif, show(x mod SCALE), "\n",
  "batches_Y = ", show(y / SCALE), ".", if (y mod SCALE) < 10 then "0" else "" endif, show(y mod SCALE), "\n",
  "profit_scaled (pence*60*SCALE) = ", show(profit_scaled), "\n"
];
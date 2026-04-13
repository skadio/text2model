% Nurse staffing with option to hire contract nurses.
% 6 start times: 2,6,10,14,18,22. Each shift lasts 8 hours (= covers 2 consecutive 4-hour periods).
% Demand is per 4-hour period across 24 hours.

int: P = 6; % number of 4-hour periods / start batches

set of int: PERIODS = 1..P;

array[PERIODS] of int: demand = [
  10, % 2:00-6:00
  15, % 6:00-10:00
  25, % 10:00-14:00
  20, % 14:00-18:00
  18, % 18:00-22:00
  12  % 22:00-2:00
];

% Costs
int: shift_hours = 8;
int: wage_regular_per_hour = 10;
int: wage_contract_per_hour = 15;

int: cost_regular = shift_hours * wage_regular_per_hour;  % 80
int: cost_contract = shift_hours * wage_contract_per_hour; % 120

% Decision variables: number of nurses starting each period (regular/contract)
array[PERIODS] of var 0..100: reg_start;
array[PERIODS] of var 0..100: con_start;

% Coverage: a nurse starting in period t covers period t and t+1 (cyclic over 6 periods)
array[PERIODS] of var 0..1000: coverage;

constraint
  forall(t in PERIODS) (
    coverage[t] = reg_start[t] + con_start[t]
                + reg_start[ if t=1 then P else t-1 endif ]
                + con_start[ if t=1 then P else t-1 endif ]
  );

% Demand satisfaction
constraint forall(t in PERIODS) (coverage[t] >= demand[t]);

% Objective: minimize total wage cost
var int: total_regular = sum(t in PERIODS)(reg_start[t]);
var int: total_contract = sum(t in PERIODS)(con_start[t]);

var int: total_cost = cost_regular * total_regular + cost_contract * total_contract;

solve minimize total_cost;

output [
  "Regular shift cost (8h): ", show(cost_regular), " yuan\n",
  "Contract shift cost (8h): ", show(cost_contract), " yuan\n\n",
  "Start times correspond to periods: 1=2:00, 2=6:00, 3=10:00, 4=14:00, 5=18:00, 6=22:00\n\n",
  "Regular starters per start time:\n",
  concat([ "  t=", show(t), ": ", show(reg_start[t]), "\n" | t in PERIODS ]),
  "\nContract starters per start time:\n",
  concat([ "  t=", show(t), ": ", show(con_start[t]), "\n" | t in PERIODS ]),
  "\nTotals:\n",
  "  Regular hired: ", show(total_regular), "\n",
  "  Contract hired: ", show(total_contract), "\n",
  "  Total cost: ", show(total_cost), " yuan\n"
];
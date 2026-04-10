include "globals.mzn";

% Time periods (4-hour blocks) over 24 hours:
% 1: 02-06, 2: 06-10, 3: 10-14, 4: 14-18, 5: 18-22, 6: 22-02
int: P = 6;
set of int: PERIODS = 1..P;

% Demand per period
array[PERIODS] of int: demand = [10, 15, 25, 20, 18, 12];

% Shift start batches at the same six times; each nurse works 8 hours (= 2 periods)
% Start s covers periods s and (s mod 6)+1
array[PERIODS, PERIODS] of int: cover =
  array2d(PERIODS, PERIODS,
    [ if (p = s) \/ (p = (s mod P) + 1) then 1 else 0 endif
      | s in PERIODS, p in PERIODS ]);

% Costs
int: hours_per_shift = 8;
int: wage_regular = 10;   % yuan/hour
int: wage_contract = 15;  % yuan/hour
int: cost_regular = hours_per_shift * wage_regular;   % per nurse per shift
int: cost_contract = hours_per_shift * wage_contract; % per nurse per shift

% Decision variables: number of nurses starting at each time, by type
array[PERIODS] of var 0..max(demand): regStart;
array[PERIODS] of var 0..max(demand): conStart;

% Coverage constraints: for each period, total on duty >= demand
constraint
  forall(p in PERIODS) (
    sum(s in PERIODS)( cover[s,p] * (regStart[s] + conStart[s]) ) >= demand[p]
  );

% Objective: minimize total wage cost over the day
var int: totalCost =
  sum(s in PERIODS)( cost_regular * regStart[s] + cost_contract * conStart[s] );

solve minimize totalCost;

output [
  "Regular starts (02,06,10,14,18,22) = ", show(regStart), "\n",
  "Contract starts (02,06,10,14,18,22) = ", show(conStart), "\n",
  "Total contract nurses hired (sum starts) = ", show(sum(s in PERIODS)(conStart[s])), "\n",
  "Total cost (yuan) = ", show(totalCost), "\n"
];
% Parameters
int: nPeriods = 6;                         % number of 4-hour periods in the day
set of int: PERIODS = 1..nPeriods;         % index set for periods

int: nStartTimes = 6;                      % number of possible shift start times (batches)
set of int: STARTS = 1..nStartTimes;       % index set for shift starts

int: shiftLengthHours = 8;                 % each nurse works 8 hours
int: periodLengthHours = 4;                % each period is 4 hours (given requirements are in 4-hour blocks)
int: periodsPerShift = shiftLengthHours div periodLengthHours; % = 2 periods covered by one shift

array[PERIODS] of int: demand =            % required nurses in each 4-hour period
  [10, 15, 25, 20, 18, 12];                % [2-6, 6-10, 10-14, 14-18, 18-22, 22-2]

int: wageRegular = 10;                     % yuan per hour for regular nurses
int: wageContract = 15;                    % yuan per hour for contract nurses

int: costPerShiftRegular = wageRegular * shiftLengthHours;   % cost per 8-hour shift
int: costPerShiftContract = wageContract * shiftLengthHours; % cost per 8-hour shift

% Coverage matrix: cover[s,p] = 1 if a nurse starting at s covers period p (8 hours => 2 consecutive periods, wrap-around)
array[STARTS, PERIODS] of int: cover =
  [| 1,1,0,0,0,0  % start at 2:00 covers 2-6 and 6-10
   | 0,1,1,0,0,0  % start at 6:00 covers 6-10 and 10-14
   | 0,0,1,1,0,0  % start at 10:00 covers 10-14 and 14-18
   | 0,0,0,1,1,0  % start at 14:00 covers 14-18 and 18-22
   | 0,0,0,0,1,1  % start at 18:00 covers 18-22 and 22-2
   | 1,0,0,0,0,1  % start at 22:00 covers 22-2 and 2-6 (wrap)
  |];

int: maxDemand = max(demand);              % helper bound (not required, but harmless)
int: maxTotalNurses = sum(demand);         % safe upper bound on total hires (very loose but valid)


% Variables
array[STARTS] of var 0..maxTotalNurses: regularStart;   % number of regular nurses starting at each batch time
array[STARTS] of var 0..maxTotalNurses: contractStart;  % number of contract nurses starting at each batch time

array[PERIODS] of var 0..maxTotalNurses: regularOnDuty;  % regular nurses working in each period
array[PERIODS] of var 0..maxTotalNurses: contractOnDuty; % contract nurses working in each period

var 0..maxTotalNurses: totalRegular;       % total regular nurses hired (all starts)
var 0..maxTotalNurses: totalContract;      % total contract nurses hired (all starts)

var 0..(costPerShiftRegular*maxTotalNurses + costPerShiftContract*maxTotalNurses): totalCost; % total wage cost


% Constraints
% Link on-duty counts to shift start decisions via the coverage matrix
constraint
  forall(p in PERIODS) (
    regularOnDuty[p] =
      sum(s in STARTS) (regularStart[s] * cover[s, p])
  );

constraint
  forall(p in PERIODS) (
    contractOnDuty[p] =
      sum(s in STARTS) (contractStart[s] * cover[s, p])
  );

% Meet (or exceed) staffing demand in every period using regular + contract nurses
constraint
  forall(p in PERIODS) (
    regularOnDuty[p] + contractOnDuty[p] >= demand[p]
  );

% Define totals across all start times
constraint
  totalRegular = sum(s in STARTS) (regularStart[s]);

constraint
  totalContract = sum(s in STARTS) (contractStart[s]);

% Define total cost from number of 8-hour shifts hired (regular and contract)
constraint
  totalCost =
    costPerShiftRegular * totalRegular
  + costPerShiftContract * totalContract;


% Objective
solve minimize totalCost;
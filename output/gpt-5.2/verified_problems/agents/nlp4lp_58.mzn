% Parameters
int: M; % Number of machines
int: P; % Number of parts

array[1..M, 1..P] of int: TimeRequired; % Hours required per batch of part p on machine m
array[1..M] of int: MachineCosts;       % Operating cost per hour for machine m
array[1..M] of int: Availability;       % Monthly availability (hours) for machine m

array[1..P] of int: Prices;     % Selling price per batch of part p
array[1..P] of int: MinBatches; % Minimum required batches per part p

int: StandardCost;  % Standard labor cost per hour for outsourced machine 1
int: OvertimeCost;  % Overtime labor cost per hour for outsourced machine 1
int: OvertimeHour;  % Max standard (non-overtime) hours billed at StandardCost (as given)

int: MinProfit; % Minimum profit requirement

% Helper bounds (derived parameters)
int: maxBatchesByMinReq = sum(p in 1..P)(MinBatches); % Simple finite upper bound driver


% Variables
% Batches[p] = number of 100-unit batches of part p to produce (nonnegative integer)
array[1..P] of var 0..(max(maxBatchesByMinReq, 1000000)): Batches;

var 0..1000000000: StandardLaborHours; % Hours on machine 1 billed at StandardCost
var 0..1000000000: OvertimeLaborHours; % Overtime hours on machine 1 billed at OvertimeCost

var -1000000000..1000000000: Revenue;   % Total monthly revenue from all parts
var -1000000000..1000000000: TotalCost; % Total monthly cost (machines + labor for machine 1)
var -1000000000..1000000000: Profit;    % Total monthly profit


% Constraints

% --- Minimum production requirements (contract fulfillment) ---
constraint
  forall(p in 1..P) (
    Batches[p] >= MinBatches[p]
  );

% --- Machine capacity constraints (machines 2..M only; machine 1 availability disregarded) ---
constraint
  forall(m in 2..M) (
    sum(p in 1..P)(TimeRequired[m,p] * Batches[p]) <= Availability[m]
  );

% --- Outsourced machine 1 labor-hour accounting (standard + overtime = total hours needed) ---
constraint
  StandardLaborHours + OvertimeLaborHours =
    sum(p in 1..P)(TimeRequired[1,p] * Batches[p]);

% --- Standard hour limit (remaining hours are overtime) ---
constraint
  StandardLaborHours <= OvertimeHour;

% --- Revenue definition ---
constraint
  Revenue = sum(p in 1..P)(Prices[p] * Batches[p]);

% --- Total cost definition (machine costs for m=2..M + labor costs for machine 1) ---
constraint
  TotalCost =
      sum(m in 2..M, p in 1..P)(MachineCosts[m] * TimeRequired[m,p] * Batches[p])
    + StandardCost * StandardLaborHours
    + OvertimeCost * OvertimeLaborHours;

% --- Profit definition ---
constraint
  Profit = Revenue - TotalCost;

% --- Minimum profit requirement ---
constraint
  Profit >= MinProfit;


% Objective
solve maximize Profit;
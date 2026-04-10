% Parameters
int: M; % Number of machines
int: P; % Number of parts

set of int: MACHINES = 1..M; % Machine index set
set of int: PARTS    = 1..P; % Part index set

array[MACHINES, PARTS] of int: TimeRequired; % Hours required to produce 1 batch of part p on machine m
array[MACHINES] of int: MachineCosts;        % Cost per operating hour for machine m
array[MACHINES] of int: Availability;        % Available operating hours per month for machine m

array[PARTS] of int: Prices;     % Selling price per batch of part p
array[PARTS] of int: MinBatches; % Minimum required batches of part p


% Variables
array[PARTS] of var int: Batches; % Number of batches produced for each part p (per month)

var int: TotalRevenue; % Total monthly revenue
var int: TotalCost;    % Total monthly operating cost
var int: Profit;       % Total monthly profit (revenue - cost)


% Constraints

% Nonnegativity (and integrality already implied by var int)
constraint forall(p in PARTS) (Batches[p] >= 0);

% --- Minimum production requirements (contract fulfillment) ---
constraint
  forall(p in PARTS) (
    Batches[p] >= MinBatches[p]
  );

% --- Machine capacity constraints (availability limits) ---
% For machines 1..M-2, enforce individual availability.
constraint
  forall(m in 1..max(0, M-2)) (
    sum(p in PARTS) (TimeRequired[m,p] * Batches[p]) <= Availability[m]
  );

% For the last two machines (M-1 and M), shared availability:
% disregard individual limits and constrain only the combined usage.
constraint
  if M >= 2 then
    sum(p in PARTS) (TimeRequired[M-1,p] * Batches[p])
  + sum(p in PARTS) (TimeRequired[M,p]   * Batches[p])
  <= Availability[M-1] + Availability[M]
  else
    % If there is only one machine, just apply its individual availability.
    sum(p in PARTS) (TimeRequired[1,p] * Batches[p]) <= Availability[1]
  endif;

% --- Financial accounting constraints ---
constraint
  TotalRevenue = sum(p in PARTS) (Prices[p] * Batches[p]);

constraint
  TotalCost =
    sum(m in MACHINES, p in PARTS) (MachineCosts[m] * TimeRequired[m,p] * Batches[p]);

constraint
  Profit = TotalRevenue - TotalCost;


% Objective
solve maximize Profit;
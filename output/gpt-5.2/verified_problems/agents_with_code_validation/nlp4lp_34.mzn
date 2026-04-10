% Parameters
int: T; % total number of time periods
int: K; % total number of generator types

% Coerce possible mismatched index sets from data (e.g., [1..5] given when T=4)
array[1..T] of int: Demand = array1d(1..T, Demand);

array[1..K] of int: NumGenerator; % number of available generators of type k
array[1..K] of int: MinLevel;     % minimum production (MW) for a running generator of type k
array[1..K] of int: MaxLevel;     % maximum production (MW) for a running generator of type k

array[1..K] of int: RunCost;      % hourly cost per generator of type k when run at minimum level
array[1..K] of float: ExtraCost;  % extra hourly cost per MW above minimum for type k
array[1..K] of int: StartCost;    % start-up cost per generator of type k

% Variables
array[1..T, 1..K] of var 0..max(NumGenerator): On;    % # generators of type k online in period t
array[1..T, 1..K] of var 0..max(NumGenerator): Start; % # generators of type k started up in period t

% Total MW produced by type k in period t (aggregated over all online units)
array[1..T, 1..K] of var 0..(max(MaxLevel) * max(NumGenerator)): Production;

% MW above minimum output for type k in period t (aggregated), nonnegative
array[1..T, 1..K] of var 0..((max(MaxLevel) - min(MinLevel)) * max(NumGenerator)): AboveMin;

% Constraints

% --- Unit availability ---
constraint
  forall(t in 1..T, k in 1..K) (
    On[t,k] <= NumGenerator[k]
  );

% --- Production bounds given # units online (aggregated min/max) ---
constraint
  forall(t in 1..T, k in 1..K) (
    Production[t,k] >= MinLevel[k] * On[t,k]
  );

constraint
  forall(t in 1..T, k in 1..K) (
    Production[t,k] <= MaxLevel[k] * On[t,k]
  );

% --- Define above-minimum production (and ensure consistency with min output) ---
constraint
  forall(t in 1..T, k in 1..K) (
    Production[t,k] = MinLevel[k] * On[t,k] + AboveMin[t,k]
  );

% --- Meet demand each period ---
constraint
  forall(t in 1..T) (
    sum(k in 1..K)(Production[t,k]) >= Demand[t]
  );

% --- Startup accounting: start-ups cover increases in online units ---
constraint
  forall(k in 1..K) (
    Start[1,k] >= On[1,k]
  );

constraint
  forall(t in 2..T, k in 1..K) (
    Start[t,k] >= On[t,k] - On[t-1,k]
  );

% --- Start-ups are bounded by availability (also implies nonnegativity via var domain) ---
constraint
  forall(t in 1..T, k in 1..K) (
    Start[t,k] <= NumGenerator[k]
  );

% Objective
solve minimize
  sum(t in 1..T, k in 1..K) (
      RunCost[k] * On[t,k]
    + ExtraCost[k] * AboveMin[t,k]
    + StartCost[k] * Start[t,k]
  );
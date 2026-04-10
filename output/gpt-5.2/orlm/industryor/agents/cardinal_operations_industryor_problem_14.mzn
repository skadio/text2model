% Parameters
int: n = 10;                                   % number of stages
array[1..n] of int: r = [3,5,2,4,6,5,4,3,2,1]; % tool requirements per stage (1-based)
int: a = 10;                                   % cost of buying a new tool
int: b = 1;                                    % cost of slow repair per tool
int: c = 3;                                    % cost of fast repair per tool
int: p = 3;                                    % slow repair duration (stages)
int: q = 1;                                    % fast repair duration (stages)

% Derived index sets for convenience
set of int: STAGES = 1..n;
set of int: STAGES_PLUS = 1..(n + p);          % track inventory through last possible slow return

% Optional simple upper bound derived from total demand
int: Rsum = sum(j in STAGES)(r[j]);

% Variables
array[STAGES] of var 0..Rsum: buy;             % number of new tools bought at stage j
array[STAGES] of var 0..Rsum: slow_send;       % tools sent to slow repair at end of stage j
array[STAGES] of var 0..Rsum: fast_send;       % tools sent to fast repair at end of stage j

array[STAGES_PLUS] of var 0..Rsum: inventory;  % tools available at start of stage t
array[STAGES] of var 0..Rsum: use;             % tools used at stage j (must meet requirement)

var int: total_cost;                           % total cost over planning horizon

% Constraints

%-------------------------------
% Demand satisfaction (usage equals requirement)
%-------------------------------
constraint forall(j in STAGES) (
  use[j] = r[j]
);

%-------------------------------
% Feasibility of repair decisions (all used tools sent to exactly one method)
%-------------------------------
constraint forall(j in STAGES) (
  slow_send[j] + fast_send[j] = use[j]
);

%-------------------------------
% Inventory flow balance with repair returns and purchases
% inventory[t] = tools available at start of stage t
% Purchases at stage t are available immediately for that stage.
% After using use[t] during stage t, remaining carry to next stage.
% Returns:
% - fast repair sent at (t-q) returns at start of stage t+1 via equation for inventory[t+1]
% - slow repair sent at (t-p) returns similarly
%-------------------------------
constraint inventory[1] = 0;

constraint forall(t in STAGES) (
  inventory[t+1] =
      inventory[t]
    + buy[t]
    + (if t - q >= 1 then fast_send[t - q] else 0 endif)
    + (if t - p >= 1 then slow_send[t - p] else 0 endif)
    - use[t]
);

%-------------------------------
% Post-horizon inventory propagation (no more purchases/usage after stage n)
% Keeps inventory well-defined while returns can still occur up to p stages later.
%-------------------------------
constraint forall(t in (n+1)..(n+p-1)) (
  inventory[t+1] =
      inventory[t]
    + (if t - q >= 1 /\ t - q <= n then fast_send[t - q] else 0 endif)
    + (if t - p >= 1 /\ t - p <= n then slow_send[t - p] else 0 endif)
);

%-------------------------------
% Availability constraint (redundant but safe): enough tools to cover use[t]
%-------------------------------
constraint forall(t in STAGES) (
  inventory[t] + buy[t]
  + (if t - q >= 1 then fast_send[t - q] else 0 endif)
  + (if t - p >= 1 then slow_send[t - p] else 0 endif)
  >= use[t]
);

%-------------------------------
% Total cost definition
%-------------------------------
constraint total_cost =
    a * sum(j in STAGES)(buy[j])
  + b * sum(j in STAGES)(slow_send[j])
  + c * sum(j in STAGES)(fast_send[j]);

% Objective
solve minimize total_cost;
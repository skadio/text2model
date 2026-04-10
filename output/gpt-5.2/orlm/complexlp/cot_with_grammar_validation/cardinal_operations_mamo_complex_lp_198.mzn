% Parameters
int: S = 5; % securities
int: C = 5; % countries/outcomes

set of int: SEC = 1..S;
set of int: OUT = 1..C;

% Country order: 1=Argentina, 2=Brazil, 3=England, 4=Germany, 5=Spain
array[SEC] of float: price = [0.75, 0.35, 0.40, 0.75, 0.65];
array[SEC] of int:   limit = [10,   5,    10,   10,   5];

% payoff[s,o] in dollars per share if outcome o occurs
array[SEC, OUT] of int: payoff =
  [| 1, 1, 1, 0, 0  % Security 1
   | 0, 0, 0, 1, 1  % Security 2
   | 1, 0, 1, 0, 1  % Security 3
   | 1, 1, 1, 1, 0  % Security 4
   | 0, 1, 0, 1, 1  % Security 5
  |];

% Scale all monetary quantities by 100 to avoid floating point in constraints
int: SCALE = 100;
array[SEC] of int: priceCents = [round(price[s] * SCALE) | s in SEC];

% Upper bound for worst-case revenue in cents (safe bound)
int: UB = sum(s in SEC)(limit[s] * SCALE);

% Variables
array[SEC] of var 0..max(limit): x;   % shares purchased of each security
var 0..UB: z;                         % worst-case revenue (cents)

% Constraints
constraint forall(s in SEC) (x[s] <= limit[s]);

% Worst-case revenue definition:
% For each outcome o: revenue(o) = sum_s x[s]*(payoff[s,o]*100 - price[s]*100)
% Enforce z <= revenue(o) for all o, then maximize z.
constraint forall(o in OUT)(
  z <= sum(s in SEC)( x[s] * (payoff[s,o]*SCALE - priceCents[s]) )
);

% Objective
solve maximize z;
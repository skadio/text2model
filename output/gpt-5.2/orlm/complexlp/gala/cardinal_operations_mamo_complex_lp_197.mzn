% Maximize worst-case (minimum across outcomes) net revenue from buying shares of securities
% Data embedded from the problem description.

include "globals.mzn";

% Countries (world cup outcomes)
int: C = 5;
set of int: Countries = 1..C;
int: ARG = 1;
int: BRA = 2;
int: ENG = 3;
int: GER = 4;
int: ESP = 5;

% Securities
int: S = 5;
set of int: Sec = 1..S;

% Prices (in dollars per share)
array[Sec] of float: price = [0.75, 0.35, 0.40, 0.75, 0.65];

% Share limits
array[Sec] of int: limit = [10, 5, 10, 10, 5];

% Payoff per share contingent on country outcome (0/1 dollars)
% Rows: securities 1..5, Cols: ARG,BRA,ENG,GER,ESP
array[Sec, Countries] of int: payoff =
 [| 1, 1, 1, 0, 0  % Sec 1
  | 0, 0, 0, 1, 1  % Sec 2
  | 1, 0, 1, 0, 1  % Sec 3
  | 1, 1, 1, 1, 0  % Sec 4
  | 0, 1, 0, 1, 1  % Sec 5
  |];

% To avoid floating arithmetic, scale all monetary amounts by 100 cents.
int: SCALE = 100;
array[Sec] of int: priceCents = [round(price[s] * SCALE) | s in Sec];  % exact here

% Decision: number of shares purchased for each security
array[Sec] of var 0..max(limit): x;
constraint forall(s in Sec)(x[s] <= limit[s]);

% Worst-case net revenue in cents:
% For each country c: revenue(c) = sum_s x[s]*(payoff[s,c]*100 - priceCents[s])
array[Countries] of var int: netRevCents;
constraint forall(c in Countries)(
  netRevCents[c] = sum(s in Sec)( x[s] * (payoff[s,c]*SCALE - priceCents[s]) )
);

var int: worstCaseCents;
constraint worstCaseCents = min(c in Countries)(netRevCents[c]);

solve maximize worstCaseCents;

output [
  "Shares x = ", show(x), "\n",
  "Net revenue cents by country [ARG,BRA,ENG,GER,ESP] = ", show(netRevCents), "\n",
  "Max worst-case revenue (cents) = ", show(worstCaseCents), "\n",
  "Max worst-case revenue (rounded dollars) = ",
    show( if worstCaseCents >= 0
          then (worstCaseCents + 50) div 100
          else -(((-worstCaseCents) + 50) div 100)
          endif
    ), "\n"
];
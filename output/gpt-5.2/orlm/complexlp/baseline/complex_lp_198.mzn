% World Cup securities: maximize worst-case (minimum across outcomes) revenue

int: S = 5; % securities
int: O = 5; % outcomes/countries

set of int: SEC = 1..S;
set of int: OUT = 1..O;

% Outcome order:
% 1 Argentina, 2 Brazil, 3 England, 4 Germany, 5 Spain

array[SEC] of float: price = [0.75, 0.35, 0.40, 0.75, 0.65];
array[SEC] of int:   limit = [10,   5,    10,   10,   5];

% payoff[s,o] in dollars per share if outcome o occurs
array[SEC, OUT] of int: payoff =
[
  % Arg Bra Eng Ger Spa
    1,  1,  1,  0,  0,  % Security 1
    0,  0,  0,  1,  1,  % Security 2
    1,  0,  1,  0,  1,  % Security 3
    1,  1,  1,  1,  0,  % Security 4
    0,  1,  0,  1,  1   % Security 5
];

array[SEC] of var 0..max(limit): x;  % shares purchased
var float: z;                        % worst-case revenue

% Revenue in each outcome: sum_s x[s] * (payoff - price)
constraint
  forall(o in OUT) (
    z <= sum(s in SEC) ( (payoff[s,o] - price[s]) * int2float(x[s]) )
  );

% Share limits
constraint forall(s in SEC) (x[s] <= limit[s]);

solve maximize z;

output [
  "Worst-case revenue (maximin) = ", show(z), "\n",
  "Shares purchased:\n",
  concat([ "  x[" ++ show(s) ++ "] = " ++ show(x[s]) ++ "\n" | s in SEC ])
];
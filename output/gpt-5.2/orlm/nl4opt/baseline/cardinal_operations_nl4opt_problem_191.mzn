% Glass panes production (regular vs tempered) - maximize profit

int: max_minutes = 300;

% Decision variables: number of panes produced (nonnegative integers)
var 0..1000: regular;
var 0..1000: tempered;

% Machine time constraints (minutes)
constraint 3 * regular + 5 * tempered <= max_minutes;  % heating
constraint 5 * regular + 8 * tempered <= max_minutes;  % cooling

% Profit (dollars)
var int: profit = 8 * regular + 10 * tempered;

solve maximize profit;

output [
  "regular panes = ", show(regular), "\n",
  "tempered panes = ", show(tempered), "\n",
  "maximum profit = $", show(profit), "\n"
];
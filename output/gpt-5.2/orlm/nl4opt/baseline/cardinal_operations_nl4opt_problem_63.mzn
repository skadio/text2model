% Bakery production planning: maximize profit with mixer and oven hour limits

int: max_hours = 3000;

% Decision variables
var 0..max_hours: bread;    % number of loaves of bread
var 0..(2*max_hours): cookies; % number of cookie batches (scaled to allow more)

% Resource constraints (avoid fractions by multiplying by 2)
% Mixer: 1*bread + 0.5*cookies <= 3000  ->  2*bread + cookies <= 6000
constraint 2 * bread + cookies <= 2 * max_hours;

% Oven: 3*bread + 1*cookies <= 3000
constraint 3 * bread + cookies <= max_hours;

% Objective: maximize profit
var int: profit = 5 * bread + 3 * cookies;
solve maximize profit;

output [
  "bread_loaves = ", show(bread), "\n",
  "cookie_batches = ", show(cookies), "\n",
  "profit = ", show(profit), "\n",
  "mixer_hours_used = ", show( (2*bread + cookies) div 2 ), ".5? (exact: (2*bread+cookies)/2)\n",
  "oven_hours_used = ", show(3*bread + cookies), "\n"
];
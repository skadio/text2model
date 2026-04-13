% Training schedule optimization (all data embedded)

% Decision variables: weekly training hours (integers)
var 0..60: x; % Group X (endurance)
var 0..50: y; % Group Y (skill)
var 0..70: z; % Group Z (strategy)

% Total fatigue score
var int: fatigue = 10*x + 15*y + 20*z;

% Constraints
constraint x + y + z <= 100;        % total hours limit
constraint x - y >= 20;             % X at least 20 hours more than Y
constraint z - x <= 30;             % Z not more than 30 hours above X

solve minimize fatigue;

output [
  "x=", show(x), " (Group X hours)\n",
  "y=", show(y), " (Group Y hours)\n",
  "z=", show(z), " (Group Z hours)\n",
  "minimum_fatigue=", show(fatigue), "\n"
];
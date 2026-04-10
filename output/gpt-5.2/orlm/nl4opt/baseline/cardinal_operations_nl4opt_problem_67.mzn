% Lawn treatment optimization: minimize total effectiveness time

% Decision variables
var 0..300: fertilizer; % units of fertilizer
var 0..300: seeds;      % units of seeds

% Objective: total time (minutes)
var float: total_time = 0.5 * int2float(fertilizer) + 1.5 * int2float(seeds);

% Constraints
constraint fertilizer + seeds <= 300;
constraint fertilizer >= 50;
constraint fertilizer <= 2 * seeds;

solve minimize total_time;

output [
  "fertilizer = ", show(fertilizer), "\n",
  "seeds = ", show(seeds), "\n",
  "total_time = ", show(total_time), " minutes\n"
];
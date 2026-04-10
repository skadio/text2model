include "globals.mzn";

% Data (embedded from problem statement)
int: budget = 10000;

int: cost_z = 1000;   int: viewers_z = 400000;
int: cost_s = 200;    int: viewers_s = 5000;
int: cost_w = 100;    int: viewers_w = 3000;

int: soorchle_max = 15;

% Decision variables: number of ads on each medium
var 0..budget div cost_z: z;   % z-tube ads
var 0..budget div cost_s: s;   % soorchle ads
var 0..budget div cost_w: w;   % wassa ads

var 0..budget: total_cost;
var 0..(budget div min([cost_z,cost_s,cost_w])): total_ads;
var 0..1000000000: total_viewers;

constraint total_cost = cost_z*z + cost_s*s + cost_w*w;
constraint total_cost <= budget;

constraint s <= soorchle_max;

constraint total_ads = z + s + w;
constraint total_ads >= 1; % avoid division-by-zero in percentage constraints

% Balance constraints:
% - at most a third of total ads on wassa: w <= floor(total_ads/3)
constraint 3*w <= total_ads;

% - at least 5% of total ads on z-tube: z >= ceil(0.05 * total_ads)
%   Use integer form: 100*z >= 5*total_ads
constraint 100*z >= 5*total_ads;

% Objective: maximize total audience
constraint total_viewers = viewers_z*z + viewers_s*s + viewers_w*w;

solve maximize total_viewers;

output [
  "z-tube ads = ", show(z), "\n",
  "soorchle ads = ", show(s), "\n",
  "wassa ads = ", show(w), "\n",
  "total ads = ", show(total_ads), "\n",
  "total cost = $", show(total_cost), "\n",
  "total viewers = ", show(total_viewers), "\n"
];
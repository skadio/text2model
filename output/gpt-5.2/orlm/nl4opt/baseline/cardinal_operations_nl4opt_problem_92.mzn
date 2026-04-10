% Advertising allocation problem (all data embedded)

int: budget = 10000;

% Costs per ad
int: cost_z = 1000;
int: cost_s = 200;
int: cost_w = 100;

% Viewers per ad
int: viewers_z = 400000;
int: viewers_s = 5000;
int: viewers_w = 3000;

% Decision variables: number of ads on each medium
var 0..budget div cost_z: z;  % z-tube
var 0..15: s;                % soorchle (capped at 15)
var 0..budget div cost_w: w;  % wassa

var 0..1000: total_ads = z + s + w;

% Budget constraint
constraint cost_z * z + cost_s * s + cost_w * w <= budget;

% Balance constraints
% At most a third of total ads on wassa: w <= (z+s+w)/3  <=>  3w <= z+s+w  <=>  2w <= z+s
constraint 2 * w <= z + s;

% At least 5% on z-tube: z >= 0.05 * total_ads  <=>  20z >= z+s+w  <=>  19z >= s+w
constraint 19 * z >= s + w;

% Objective: maximize total viewers
var int: total_viewers = viewers_z * z + viewers_s * s + viewers_w * w;

solve maximize total_viewers;

output [
  "z-tube ads: ", show(z), "\n",
  "soorchle ads: ", show(s), "\n",
  "wassa ads: ", show(w), "\n",
  "total ads: ", show(total_ads), "\n",
  "total cost: ", show(cost_z*z + cost_s*s + cost_w*w), "\n",
  "total viewers: ", show(total_viewers), "\n"
];
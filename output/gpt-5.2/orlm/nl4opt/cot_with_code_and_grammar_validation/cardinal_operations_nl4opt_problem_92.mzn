% Parameters
int: cost_z = 1000;
int: cost_s = 200;
int: cost_w = 100;

int: viewers_z = 400000;
int: viewers_s = 5000;
int: viewers_w = 3000;

int: budget = 10000;
int: s_max = 15;

% Variables
var 0..(budget div cost_z): z;
var 0..min(s_max, budget div cost_s): s;
var 0..(budget div cost_w): w;

var 0..(budget div min(cost_z, min(cost_s, cost_w))): total_ads;

% Constraints
constraint total_ads = z + s + w;

constraint cost_z * z + cost_s * s + cost_w * w <= budget;

constraint s <= s_max;

% At most one third on wassa: w <= floor((z+s+w)/3)  <=>  3w <= z+s+w  <=>  2w <= z+s
constraint 2 * w <= z + s;

% At least 5% on z-tube: z >= 0.05*(z+s+w)  <=>  20z >= z+s+w  <=>  19z >= s+w
constraint 19 * z >= s + w;

% Objective
solve maximize viewers_z * z + viewers_s * s + viewers_w * w;
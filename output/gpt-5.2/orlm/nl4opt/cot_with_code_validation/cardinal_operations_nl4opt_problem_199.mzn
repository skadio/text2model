% Parameters
int: nPlatforms = 3;
int: PI = 1;
int: BETA = 2;
int: GAMMA = 3;

array[1..nPlatforms] of int: cost = [1200, 2000, 4000];
array[1..nPlatforms] of int: reach = [2000, 5000, 9000];

int: budget = 20000;
int: beta_max = 8;

% Variables
array[1..nPlatforms] of var 0..(budget div min(cost)): x; % number of commercials per platform
var 0..(budget div min(cost) * max(reach)): total_reach;
var 0..(budget div min(cost)): total_ads;

% Constraints
constraint total_ads = sum(i in 1..nPlatforms)(x[i]);
constraint total_reach = sum(i in 1..nPlatforms)(reach[i] * x[i]);

constraint sum(i in 1..nPlatforms)(cost[i] * x[i]) <= budget;

constraint x[BETA] <= beta_max;

% At most a third on Gamma: 3*x[GAMMA] <= total_ads
constraint 3 * x[GAMMA] <= total_ads;

% At least 20% on Pi: 5*x[PI] >= total_ads
constraint 5 * x[PI] >= total_ads;

% Objective
solve maximize total_reach;
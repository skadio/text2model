% Parameters (with values embedded)
int: nPlatforms = 3;
set of int: P = 1..nPlatforms;

int: PI = 1;
int: BETA = 2;
int: GAMMA = 3;

array[P] of int: cost = [1200, 2000, 4000];
array[P] of int: reach = [2000, 5000, 9000];

int: budget = 20000;
int: beta_max = 8;

% Variables
array[P] of var 0..16: x; % number of commercials on each platform
var 0..48: total_ads;

% Constraints
constraint total_ads = sum(p in P)(x[p]);

% Budget constraint
constraint sum(p in P)(cost[p] * x[p]) <= budget;

% Platform-specific limit
constraint x[BETA] <= beta_max;

% Mix constraints:
% At most a third of all commercials on Gamma Live: 3*x_gamma <= total_ads
constraint 3 * x[GAMMA] <= total_ads;

% At least 20% on Pi TV: x_pi >= 0.2*total_ads -> 5*x_pi >= total_ads
constraint 5 * x[PI] >= total_ads;

% Ensure at least one commercial so ratio constraints are meaningful
constraint total_ads >= 1;

% Objective
solve maximize sum(p in P)(reach[p] * x[p]);
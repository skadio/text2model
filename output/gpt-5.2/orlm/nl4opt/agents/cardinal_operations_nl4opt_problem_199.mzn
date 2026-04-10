% Parameters
set of int: PLATFORMS = 1..3;                 % 1=Pi TV, 2=Beta Video, 3=Gamma Live

array[PLATFORMS] of int: cost = [1200, 2000, 4000];       % cost per commercial ($)
array[PLATFORMS] of int: reach = [2000, 5000, 9000];      % expected viewers per commercial

int: budget = 20000;                           % weekly budget ($)
int: beta_max = 8;                             % maximum commercials on Beta Video

float: gamma_max_frac = 1.0/3.0;               % (not used directly; enforced via integer form)
float: pi_min_frac = 0.20;                     % (not used directly; enforced via integer form)

int: PI = 1;
int: BETA = 2;
int: GAMMA = 3;

% Variables
% Upper bound: max number of ads if all spending went to the cheapest platform
array[PLATFORMS] of var 0..(budget div min(cost)): n_ads;     % number of commercials on each platform
var 0..(budget div min(cost)): total_ads;                     % total number of commercials
var 0..(budget div min(cost) * max(reach)): total_reach;      % total expected audience

% Constraints
% --- Total commercials and total reach definitions ---
constraint
  total_ads = sum(p in PLATFORMS)(n_ads[p]);
constraint
  total_reach = sum(p in PLATFORMS)(reach[p] * n_ads[p]);

% --- Budget constraint (total spending within weekly budget) ---
constraint
  sum(p in PLATFORMS)(cost[p] * n_ads[p]) <= budget;

% --- Platform-specific cap: Beta Video limits commercials to beta_max ---
constraint
  n_ads[BETA] <= beta_max;

% --- Share constraints across platforms (use integer-safe forms) ---
% At most one third of all commercials on Gamma Live:
constraint
  3 * n_ads[GAMMA] <= total_ads;

% At least 20% of all commercials on Pi TV:
constraint
  5 * n_ads[PI] >= total_ads;

% --- Non-degeneracy (avoid meaningless share constraints at total_ads=0) ---
constraint
  total_ads >= 1;

% Objective
solve maximize total_reach;
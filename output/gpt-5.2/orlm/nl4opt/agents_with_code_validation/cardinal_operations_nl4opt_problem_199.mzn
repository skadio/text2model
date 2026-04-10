% Parameters
% Streaming platforms: 1=Pi TV, 2=Beta Video, 3=Gamma Live
int: nPlatforms = 3;
set of int: PLATFORMS = 1..nPlatforms;

array[PLATFORMS] of int: cost = [1200, 2000, 4000];   % cost per commercial ($)
array[PLATFORMS] of int: reach = [2000, 5000, 9000];  % expected viewers per commercial

int: budget = 20000;  % weekly budget ($)
int: betaMax = 8;     % max commercials on Beta Video

% Ratio constraints (avoid floating point):
% Gamma: x_gamma <= (1/3) * total  <=>  3*x_gamma <= total
% Pi:    x_pi    >= 0.20 * total   <=>  5*x_pi >= total
int: gammaIdx = 3;
int: piIdx = 1;
int: gammaRatioNum = 3;  % multiplier for x_gamma
int: gammaRatioDen = 1;  % multiplier for total (so: 3*x_gamma <= 1*total)
int: piRatioNum = 5;     % multiplier for x_pi
int: piRatioDen = 1;     % multiplier for total (so: 5*x_pi >= 1*total)

% Simple upper bounds from budget alone
int: maxPi    = budget div cost[1];
int: maxBeta  = min(betaMax, budget div cost[2]);
int: maxGamma = budget div cost[3];
int: maxTotal = maxPi + maxBeta + maxGamma;


% Variables
array[PLATFORMS] of var 0..maxTotal: x;   % number of commercials on each platform
var 0..maxTotal: totalAds;                % total number of commercials
var 0..(maxTotal * max(reach)): audience; % total expected audience reach


% Constraints

% --- Total number of commercials (definition) ---
constraint
  totalAds = sum(p in PLATFORMS)(x[p]);

% --- Budget limit ---
constraint
  sum(p in PLATFORMS)(cost[p] * x[p]) <= budget;

% --- Platform-specific limit: Beta Video max commercials ---
constraint
  x[2] <= betaMax;

% --- Share constraints to ensure a mix of platforms (integer ratios) ---
% At most one third of all commercials on Gamma Live: 3 * x_gamma <= total
constraint
  gammaRatioNum * x[gammaIdx] <= gammaRatioDen * totalAds;

% At least 20% of all commercials on Pi TV: 5 * x_pi >= total
constraint
  piRatioNum * x[piIdx] >= piRatioDen * totalAds;

% --- Audience reach (definition) ---
constraint
  audience = sum(p in PLATFORMS)(reach[p] * x[p]);


% Objective
solve maximize audience;
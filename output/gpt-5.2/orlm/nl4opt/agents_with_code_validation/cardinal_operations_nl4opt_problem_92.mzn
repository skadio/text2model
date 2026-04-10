% Parameters
% All data is embedded directly in this model (no .dzn expected).

int: nMedia = 3;

set of int: MEDIA = 1..nMedia;
int: ZTUBE = 1;
int: SOORCHLE = 2;
int: WASSA = 3;

array[MEDIA] of int: cost = [1000, 200, 100];            % cost per ad ($)
array[MEDIA] of int: viewers = [400000, 5000, 3000];     % viewers per ad

int: budget = 10000;                                     % weekly budget ($)
int: maxSoorchleAds = 15;                                % platform limit

float: maxWassaShare = 1.0/3.0;                          % at most 1/3 on wassa (not used directly; enforced via integer form)
float: minZtubeShare = 0.05;                             % at least 5% on z-tube (not used directly; enforced via integer form)


% Variables
array[MEDIA] of var 0..(budget div min(cost)): ads;      % number of ads per medium
var 0..(nMedia * (budget div min(cost))): totalAds;      % total number of ads
var 0..sum(i in MEDIA)(viewers[i] * (budget div min(cost))): totalAudience; % total viewers


% Constraints

% --- Derived totals ----------------------------------------------------------
constraint totalAds = sum(i in MEDIA)(ads[i]);
constraint totalAudience = sum(i in MEDIA)(viewers[i] * ads[i]);

% --- Budget constraint -------------------------------------------------------
constraint sum(i in MEDIA)(cost[i] * ads[i]) <= budget;

% --- Platform-specific limit (Soorchle) -------------------------------------
constraint ads[SOORCHLE] <= maxSoorchleAds;

% --- Media mix / balance constraints ----------------------------------------
% At most one third of all ads on Wassa:
% ads[WASSA] / totalAds <= 1/3  ->  3*ads[WASSA] <= totalAds
constraint 3 * ads[WASSA] <= totalAds;

% At least 5% of all ads on Z-tube:
% ads[ZTUBE] / totalAds >= 0.05  ->  20*ads[ZTUBE] >= totalAds
constraint 20 * ads[ZTUBE] >= totalAds;

% Ensure shares are well-defined (avoid the trivial totalAds=0 case)
constraint totalAds >= 1;


% Objective
solve maximize totalAudience;
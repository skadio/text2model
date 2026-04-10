% Parameters
int: nFeeds = 5;                          % number of feed types
set of int: FEEDS = 1..nFeeds;            % index set for feeds

float: minProtein = 700.0;                % minimum daily protein requirement (g)
float: minMinerals = 30.0;                % minimum daily minerals requirement (g)
float: minVitamins = 100.0;               % minimum daily vitamins requirement (mg)

% Nutritional content per gram of each feed
array[FEEDS] of float: protein  = [3.0, 2.0, 1.0, 6.0, 18.0];    % (g)
array[FEEDS] of float: minerals = [1.0, 0.5, 0.2, 2.0, 0.5];     % (g)
array[FEEDS] of float: vitamins = [0.5, 1.0, 0.2, 2.0, 0.8];     % (mg)

% Price coefficients used directly in the objective (as provided in the table)
array[FEEDS] of float: price = [0.2, 0.7, 0.4, 0.3, 0.8];

% Variables
array[FEEDS] of var float: x;             % amount of each feed selected (grams)

% Constraints
% Non-negativity bounds
constraint forall(f in FEEDS) (x[f] >= 0.0);

% --- Nutritional minimum requirements ---
constraint sum(f in FEEDS)(protein[f]  * x[f]) >= minProtein;
constraint sum(f in FEEDS)(minerals[f] * x[f]) >= minMinerals;
constraint sum(f in FEEDS)(vitamins[f] * x[f]) >= minVitamins;

% Objective
solve minimize sum(f in FEEDS)(price[f] * x[f]);
% Parameters
int: K;                           % Number of mines
int: MaxWork;                     % Max number of mines that can be operated in a year
array[1..K] of float: Royalty;    % Yearly royalty cost for mine k (paid if mine is kept open)
array[1..K] of float: Limit;      % Max production (tons) per year for mine k
array[1..K] of float: Quality;    % Quality of ore from mine k

int: I;                                % Number of years (length of RequiredQuality)
array[1..I] of float: RequiredQuality; % Required blended quality in year i

float: Price;                     % Selling price per ton
float: Discount;                  % Discount rate per annum (e.g., 0.1)

% Useful index sets
set of int: MINES = 1..K;
set of int: YEARS = 1..I;

% Variables
array[YEARS, MINES] of var 0.0..1.0: work;          % 1 if mine k is worked in year i, else 0
array[YEARS, MINES] of var 0.0..1.0: open;          % 1 if mine k is kept open in year i, else 0
array[YEARS, MINES] of var 0.0..max(Limit): produce; % Tons produced from mine k in year i

array[YEARS] of var 0.0..(K * max(Limit)): total_production; % Total tons produced in year i

% Constraints

% --- Mine operation capacity per year (at most MaxWork mines worked) ---
constraint
  forall(i in YEARS) (
    sum(k in MINES)(work[i,k]) <= MaxWork
  );

% --- Logical link: a mine can only be worked if it is open that year ---
constraint
  forall(i in YEARS, k in MINES) (
    work[i,k] <= open[i,k]
  );

% --- Production only if worked, and bounded by yearly mine limit ---
constraint
  forall(i in YEARS, k in MINES) (
    produce[i,k] <= Limit[k] * work[i,k]
  );

% --- Mine opening persistence: once closed, cannot be reopened later ---
% open must be non-increasing over years for each mine
constraint
  forall(k in MINES, i in 1..I-1) (
    open[i,k] >= open[i+1,k]
  );

% --- Total production definition per year ---
constraint
  forall(i in YEARS) (
    total_production[i] = sum(k in MINES)(produce[i,k])
  );

% --- Blending quality requirement: weighted average equals RequiredQuality ---
% Enforces: sum_k (Quality[k] * produce[i,k]) = RequiredQuality[i] * total_production[i]
constraint
  forall(i in YEARS) (
    sum(k in MINES)(Quality[k] * produce[i,k]) = RequiredQuality[i] * total_production[i]
  );

% --- Ensure meaningful quality equation: require some production each year ---
constraint
  forall(i in YEARS) (
    total_production[i] > 0.0
  );

% --- Enforce 0/1 decisions (since work/open declared as var 0.0..1.0) ---
constraint
  forall(i in YEARS, k in MINES) (
    work[i,k] = 0.0 \/ work[i,k] = 1.0
  );

constraint
  forall(i in YEARS, k in MINES) (
    open[i,k] = 0.0 \/ open[i,k] = 1.0
  );

% Objective
% Maximize total discounted profit = discounted revenues - discounted royalties
solve maximize
  sum(i in YEARS) (
    (Price * total_production[i]) / pow(1.0 + Discount, i - 1)
    - (sum(k in MINES)(Royalty[k] * open[i,k])) / pow(1.0 + Discount, i - 1)
  );
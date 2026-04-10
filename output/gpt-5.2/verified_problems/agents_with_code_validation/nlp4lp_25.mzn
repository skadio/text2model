% Parameters
int: K;                                 % Number of mines
int: MaxWork;                           % Maximum number of mines that can be operated in a year

array[1..K] of float: Royalty;          % Yearly royalty cost for mine k (paid if mine is kept open)
array[1..K] of float: Limit;            % Maximum production (tons) from mine k in a year
array[1..K] of float: Quality;          % Quality of ore from mine k

array[int] of float: RequiredQuality;   % Required blended quality in each year
int: I = length(RequiredQuality);       % Number of years (derived from RequiredQuality)

float: Price;                           % Price per ton of blended ore sold
float: Discount;                        % Annual discount rate (e.g., 0.1)

set of int: MINES = 1..K;
set of int: YEARS = 1..I;

% Variables
array[YEARS, MINES] of var bool: work;        % True if mine k is worked in year i
array[YEARS, MINES] of var bool: open;        % True if mine k is kept open in year i (royalty payable)
array[YEARS, MINES] of var float: produce;    % Tons produced from mine k in year i
array[YEARS] of var float: total_output;      % Total blended tons produced in year i

% Constraints

% At most MaxWork mines can be worked in any year.
constraint
  forall(i in YEARS) (
    sum(k in MINES)(bool2int(work[i,k])) <= MaxWork
  );

% Production only if worked, and within capacity.
constraint
  forall(i in YEARS, k in MINES) (
    produce[i,k] >= 0.0 /\
    produce[i,k] <= Limit[k] * bool2int(work[i,k])
  );

% Total output definition.
constraint
  forall(i in YEARS) (
    total_output[i] = sum(k in MINES)(produce[i,k])
  );

% If a mine is worked in a year, it must be open in that year.
constraint
  forall(i in YEARS, k in MINES) (
    work[i,k] -> open[i,k]
  );

% Once closed, stays closed.
constraint
  forall(k in MINES, i in 1..I-1) (
    bool2int(open[i,k]) >= bool2int(open[i+1,k])
  );

% If worked in any future year, must be open in all earlier years.
constraint
  forall(k in MINES, i in YEARS, j in YEARS where j > i) (
    work[j,k] -> open[i,k]
  );

% Blending quality requirement each year:
% sum_k produce[i,k] * Quality[k] = RequiredQuality[i] * total_output[i]
constraint
  forall(i in YEARS) (
    sum(k in MINES)(produce[i,k] * Quality[k]) = RequiredQuality[i] * total_output[i]
  );

% Objective: maximize discounted profit (revenue - royalties).
solve maximize
  sum(i in YEARS)(
    ( Price * total_output[i]
      - sum(k in MINES)(Royalty[k] * bool2int(open[i,k]))
    ) / pow(1.0 + Discount, i - 1)
  );
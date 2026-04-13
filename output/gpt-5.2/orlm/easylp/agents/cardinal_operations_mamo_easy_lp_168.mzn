% Parameters
int: nChannels = 3;                          % Number of advertising channels
set of int: CHANNELS = 1..nChannels;         % Index set for channels

array[CHANNELS] of string: channelName = ["X","Y","Z"];  % Channel labels (optional)

int: totalBudgetMax = 1000;                  % Total budget upper limit ($)

array[CHANNELS] of int: minBudget = [200, 150, 100];      % Minimum viable budget per channel ($)
array[CHANNELS] of int: costPerUnit = [50, 60, 70];       % Cost per unit effectiveness ($/unit)

% Variables
array[CHANNELS] of var 0..totalBudgetMax: budget;         % Budget allocated to each channel ($, integer)
var 0..(totalBudgetMax * max(costPerUnit)): totalCost;    % Total cost ($), integer

% Constraints
% --- Minimum viable budget per channel ---
constraint
  forall(c in CHANNELS) (
    budget[c] >= minBudget[c]
  );

% --- Total budget limit across all channels ---
constraint
  sum(c in CHANNELS)(budget[c]) <= totalBudgetMax;

% --- Define total cost from channel budgets and per-unit costs ---
constraint
  totalCost = sum(c in CHANNELS)(costPerUnit[c] * budget[c]);

% Objective
solve minimize totalCost;
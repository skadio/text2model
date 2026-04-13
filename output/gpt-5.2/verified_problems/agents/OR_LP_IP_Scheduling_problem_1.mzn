% Parameters
int: num_skis;                         % Number of available skis
int: num_skiers;                       % Number of skiers

set of int: SKIS = 1..num_skis;        % Index set for skis
set of int: SKIERS = 1..num_skiers;    % Index set for skiers

array[SKIS] of int: ski_heights;       % Height of each ski
array[SKIERS] of int: skier_heights;   % Height of each skier

% Variables
array[SKIERS] of var SKIS: ski_for_skier;          % Assigned ski index for each skier
array[SKIERS] of var int: disparity;               % Absolute difference in heights
var int: total_disparity;                          % Sum of disparities across all skiers

% Constraints
% Each ski can be assigned to at most one skier (requires num_skis >= num_skiers for feasibility).
constraint
  all_different(ski_for_skier);

% Define disparity per skier as absolute height difference to assigned ski.
constraint
  forall(i in SKIERS) (
    disparity[i] = abs(skier_heights[i] - ski_heights[ski_for_skier[i]])
  );

% Aggregate total disparity.
constraint
  total_disparity = sum(i in SKIERS)(disparity[i]);

% Objective
solve minimize total_disparity;
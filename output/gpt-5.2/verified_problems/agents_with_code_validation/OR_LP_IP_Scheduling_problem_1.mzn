include "globals.mzn";

% Parameters
int: num_skis;                          % Number of available skis
int: num_skiers;                        % Number of skiers

set of int: SKIS = 1..num_skis;         % Index set for skis
set of int: SKIERS = 1..num_skiers;     % Index set for skiers

array[SKIS] of int: ski_heights;        % Height of each ski
array[SKIERS] of int: skier_heights;    % Height of each skier

% Variables
array[SKIERS] of var SKIS: ski_of_skier;   % Assigned ski index for each skier
array[SKIERS] of var int: disparity;       % Absolute height difference per skier
var int: total_disparity;                  % Sum of all disparities

% Constraints
% No ski is assigned to more than one skier (injective assignment).
constraint all_different(ski_of_skier);

% Define per-skier disparity as the absolute difference between skier height and assigned ski height.
constraint
  forall(i in SKIERS) (
    disparity[i] = abs(skier_heights[i] - ski_heights[ski_of_skier[i]])
  );

% Aggregate total disparity.
constraint
  total_disparity = sum(i in SKIERS)(disparity[i]);

% Objective
solve minimize total_disparity;
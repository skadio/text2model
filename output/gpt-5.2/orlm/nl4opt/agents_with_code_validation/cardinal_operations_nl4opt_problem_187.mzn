% Parameters
int: vitC_per_shots = 30;          % vitamin C units required per batch of shots
int: vitD_per_shots = 40;          % vitamin D units required per batch of shots
int: vitC_per_pills = 50;          % vitamin C units required per batch of pills
int: vitD_per_pills = 30;          % vitamin D units required per batch of pills

int: avail_vitC = 1200;            % total available vitamin C units
int: avail_vitD = 1500;            % total available vitamin D units

int: people_per_shots = 10;        % people supplied per batch of shots
int: people_per_pills = 7;         % people supplied per batch of pills

int: max_shots_batches = 10;       % maximum number of batches of shots

% Variables
var 0..max_shots_batches: shots_batches;  % number of batches of vitamin shots
var 0..1000: pills_batches;               % number of batches of vitamin pills (safe upper bound)

var 0..100000: total_people;              % total people supplied (objective variable)

% Constraints
% Link total_people to production decisions
constraint
  total_people = people_per_shots * shots_batches
               + people_per_pills * pills_batches;

% Vitamin availability constraints
constraint
  vitC_per_shots * shots_batches + vitC_per_pills * pills_batches <= avail_vitC;

constraint
  vitD_per_shots * shots_batches + vitD_per_pills * pills_batches <= avail_vitD;

% Popularity requirement: produce more pills than shots
constraint
  pills_batches > shots_batches;

% Objective
solve maximize total_people;
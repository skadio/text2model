% Parameters
int: nYears = 2;                              % Planning horizon (2 years)
set of int: YEARS = 1..nYears;                % Year index set

array[YEARS] of int: a = [10, 15];            % Annual fighter jet production a_j
int: pilotsPerTrainingJetPerYear = 5;         % Pilots trained per training jet per year

% Variables
array[YEARS] of var 0..max(a): trainingJets;  % Jets allocated to training each year (bounded by production)
array[YEARS] of var 0..(max(a)*pilotsPerTrainingJetPerYear): trainedPilots; % Pilots trained each year
var 0..(sum(a)*pilotsPerTrainingJetPerYear): totalTrainedPilotsEndYear2;    % Total trained pilots by end of year 2

% Constraints
% --- Training jet allocation cannot exceed annual production ---
constraint
  forall(y in YEARS) (
    trainingJets[y] <= a[y]
  );

% --- Link trained pilots to number of training jets (5 pilots per training jet per year) ---
constraint
  forall(y in YEARS) (
    trainedPilots[y] = pilotsPerTrainingJetPerYear * trainingJets[y]
  );

% --- Total trained pilots available by end of year 2 (sum over both years) ---
constraint
  totalTrainedPilotsEndYear2 = sum(y in YEARS)(trainedPilots[y]);

% Objective
solve maximize totalTrainedPilotsEndYear2;
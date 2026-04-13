% Parameters
int: nYears = 2;                               % Planning horizon (years 1..2)
set of int: YEARS = 1..nYears;                 % Year index set

array[YEARS] of int: a = [10, 15];             % Annual production of fighter jets a[y]
int: pilotsPerTrainingJetPerYear = 5;          % Pilots trained per training jet per year

% Variables
array[YEARS] of var 0..max(a): trainingJets;   % Jets allocated to training in each year
array[YEARS] of var 0..max(a): combatJets;     % Jets allocated to combat in each year

array[YEARS] of var 0..(pilotsPerTrainingJetPerYear * max(a)): trainedPilotsInYear;
                                               % Pilots trained during each year
var 0..(sum(y in YEARS)(pilotsPerTrainingJetPerYear * a[y])): totalTrainedPilotsByEndYear2;
                                               % Total trained pilots available by end of year 2

% Constraints

% --- Jet allocation balance per year (all produced jets are assigned) ---
constraint
  forall(y in YEARS) (
    trainingJets[y] + combatJets[y] = a[y]
  );

% --- Training output per year (each training jet trains a fixed number of pilots) ---
constraint
  forall(y in YEARS) (
    trainedPilotsInYear[y] = pilotsPerTrainingJetPerYear * trainingJets[y]
  );

% --- Total trained pilots available by end of year 2 (sum of yearly training) ---
constraint
  totalTrainedPilotsByEndYear2 = sum(y in YEARS)(trainedPilotsInYear[y]);

% --- Pilot availability implication for combat jets in subsequent years ---
% Trained pilots from years 1..(y-1) can operate combat jets in year y.
% For y=1 there are no prior trained pilots, so combatJets[1] must be 0.
constraint
  combatJets[1] = 0;

constraint
  forall(y in 2..nYears) (
    combatJets[y] <= sum(t in 1..(y-1))(trainedPilotsInYear[t])
  );

% Objective
solve maximize totalTrainedPilotsByEndYear2;
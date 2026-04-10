% Parameters
int: TotalAcres;          % Total available acres of the lake
int: FishPerNetAcre;      % Fish caught per acre using a net
int: FishPerLineAcre;     % Fish caught per acre using a fishing line
int: BaitPerNetAcre;      % Bait required per acre using a net
int: BaitPerLineAcre;     % Bait required per acre using a fishing line
int: TotalBait;           % Total available bait
int: PainPerNetAcre;      % Pain caused per acre using a net
int: PainPerLineAcre;     % Pain caused per acre using a fishing line
int: MaxPain;             % Maximum tolerable pain for the fisherman

% Variables
var 0..TotalAcres: NetAcres;   % Acres fished using a net
var 0..TotalAcres: LineAcres;  % Acres fished using a fishing line

% Total fish caught (upper bound uses the better fish yield per acre)
var 0..(TotalAcres * max(FishPerNetAcre, FishPerLineAcre)): TotalFish;

% Constraints
% Link total fish to acres fished by each method
constraint
  TotalFish = FishPerNetAcre * NetAcres + FishPerLineAcre * LineAcres;

% Total lake area limit (cannot fish more acres than available)
constraint
  NetAcres + LineAcres <= TotalAcres;

% Total bait availability constraint
constraint
  BaitPerNetAcre * NetAcres + BaitPerLineAcre * LineAcres <= TotalBait;

% Maximum tolerable pain constraint
constraint
  PainPerNetAcre * NetAcres + PainPerLineAcre * LineAcres <= MaxPain;

% Objective
solve maximize TotalFish;
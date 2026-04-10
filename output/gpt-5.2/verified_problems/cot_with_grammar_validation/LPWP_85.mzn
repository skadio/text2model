% Parameters
int: TotalAcres;
int: FishPerNetAcre;
int: FishPerLineAcre;
int: BaitPerNetAcre;
int: BaitPerLineAcre;
int: TotalBait;
int: PainPerNetAcre;
int: PainPerLineAcre;
int: MaxPain;

% Variables
var 0..TotalAcres: NetAcres;
var 0..TotalAcres: LineAcres;

% Constraints
constraint NetAcres + LineAcres <= TotalAcres;

constraint BaitPerNetAcre * NetAcres + BaitPerLineAcre * LineAcres <= TotalBait;

constraint PainPerNetAcre * NetAcres + PainPerLineAcre * LineAcres <= MaxPain;

% Objective
solve maximize FishPerNetAcre * NetAcres + FishPerLineAcre * LineAcres;
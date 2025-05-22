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
constraint
    NetAcres + LineAcres <= TotalAcres;

constraint
    NetAcres * BaitPerNetAcre + LineAcres * BaitPerLineAcre <= TotalBait;

constraint
    NetAcres * PainPerNetAcre + LineAcres * PainPerLineAcre <= MaxPain;

% Objective
solve maximize 
    NetAcres * FishPerNetAcre + LineAcres * FishPerLineAcre;
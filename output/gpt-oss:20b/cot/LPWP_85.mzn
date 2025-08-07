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
var 0..TotalAcres: NetAcresVar;
var 0..TotalAcres: LineAcresVar;

% Constraints
constraint NetAcresVar + LineAcresVar <= TotalAcres;
constraint NetAcresVar * BaitPerNetAcre + LineAcresVar * BaitPerLineAcre <= TotalBait;
constraint NetAcresVar * PainPerNetAcre + LineAcresVar * PainPerLineAcre <= MaxPain;

% Objective
solve maximize NetAcresVar * FishPerNetAcre + LineAcresVar * FishPerLineAcre;
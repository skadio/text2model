% Fisherman resource allocation model

% Parameters (must be provided in .dzn)
int: TotalAcres;
int: FishPerNetAcre;
int: FishPerLineAcre;
int: BaitPerNetAcre;
int: BaitPerLineAcre;
int: TotalBait;
int: PainPerNetAcre;
int: PainPerLineAcre;
int: MaxPain;

% Decision variables
var 0..TotalAcres: NetAcres;
var 0..TotalAcres: LineAcres;

% Constraints
constraint NetAcres + LineAcres <= TotalAcres;

constraint BaitPerNetAcre * NetAcres + BaitPerLineAcre * LineAcres <= TotalBait;

constraint PainPerNetAcre * NetAcres + PainPerLineAcre * LineAcres <= MaxPain;

% Objective (maximize fish caught)
var int: TotalFish = FishPerNetAcre * NetAcres + FishPerLineAcre * LineAcres;

solve maximize TotalFish;

output [
  "NetAcres = ", show(NetAcres), "\n",
  "LineAcres = ", show(LineAcres), "\n",
  "TotalFish = ", show(TotalFish), "\n"
];
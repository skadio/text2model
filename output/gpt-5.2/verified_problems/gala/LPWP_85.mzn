% Fisherman resource allocation (Net vs Line) - maximize fish caught

%----------------------------
% Input data (provided in .dzn)
%----------------------------
int: TotalAcres;
int: FishPerNetAcre;
int: FishPerLineAcre;
int: BaitPerNetAcre;
int: BaitPerLineAcre;
int: TotalBait;
int: PainPerNetAcre;
int: PainPerLineAcre;
int: MaxPain;

%----------------------------
% Decision variables
%----------------------------
var 0..TotalAcres: NetAcres;
var 0..TotalAcres: LineAcres;

%----------------------------
% Constraints
%----------------------------
constraint NetAcres + LineAcres <= TotalAcres;

constraint BaitPerNetAcre * NetAcres + BaitPerLineAcre * LineAcres <= TotalBait;

constraint PainPerNetAcre * NetAcres + PainPerLineAcre * LineAcres <= MaxPain;

%----------------------------
% Objective
%----------------------------
var int: TotalFish = FishPerNetAcre * NetAcres + FishPerLineAcre * LineAcres;

solve maximize TotalFish;

%----------------------------
% Output
%----------------------------
output [
  "NetAcres = ", show(NetAcres), "\n",
  "LineAcres = ", show(LineAcres), "\n",
  "TotalFish = ", show(TotalFish), "\n",
  "TotalAcresUsed = ", show(NetAcres + LineAcres), " / ", show(TotalAcres), "\n",
  "TotalBaitUsed = ", show(BaitPerNetAcre * NetAcres + BaitPerLineAcre * LineAcres),
    " / ", show(TotalBait), "\n",
  "TotalPain = ", show(PainPerNetAcre * NetAcres + PainPerLineAcre * LineAcres),
    " / ", show(MaxPain), "\n"
];
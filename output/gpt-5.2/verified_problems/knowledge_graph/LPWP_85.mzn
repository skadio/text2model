float: TotalAcres;
float: FishPerNetAcre;
float: FishPerLineAcre;
float: BaitPerNetAcre;
float: BaitPerLineAcre;
float: TotalBait;
float: PainPerNetAcre;
float: PainPerLineAcre;
float: MaxPain;

var float: NetAcres;
var float: LineAcres;

constraint NetAcres >= 0.0;
constraint LineAcres >= 0.0;

constraint NetAcres + LineAcres <= TotalAcres;

constraint BaitPerNetAcre * NetAcres + BaitPerLineAcre * LineAcres <= TotalBait;

constraint PainPerNetAcre * NetAcres + PainPerLineAcre * LineAcres <= MaxPain;

var float: TotalFish = FishPerNetAcre * NetAcres + FishPerLineAcre * LineAcres;

solve maximize TotalFish;

output [
  "NetAcres = ", show(NetAcres), "\n",
  "LineAcres = ", show(LineAcres), "\n",
  "TotalFish = ", show(TotalFish), "\n"
];
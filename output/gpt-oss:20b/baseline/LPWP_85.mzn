var int: NetAcres;
var int: LineAcres;

constraint NetAcres >= 0;
constraint LineAcres >= 0;
constraint NetAcres + LineAcres <= TotalAcres;

constraint NetAcres * BaitPerNetAcre + LineAcres * BaitPerLineAcre <= TotalBait;
constraint NetAcres * PainPerNetAcre + LineAcres * PainPerLineAcre <= MaxPain;

var int: TotalFish = FishPerNetAcre * NetAcres + FishPerLineAcre * LineAcres;

solve maximize TotalFish;

output [
    "NetAcres: ", show(NetAcres), "\n",
    "LineAcres: ", show(LineAcres), "\n",
    "TotalFish: ", show(TotalFish), "\n"
];
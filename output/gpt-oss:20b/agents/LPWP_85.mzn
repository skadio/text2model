% MiniZinc model: Maximize fish caught with nets and lines

%----- Input data ------------------------------------------------------------
int: NetAcres;          % unused in constraints, included for completeness
int: LineAcres;         % unused in constraints, included for completeness
int: TotalAcres;
int: FishPerNetAcre;
int: FishPerLineAcre;
int: BaitPerNetAcre;
int: BaitPerLineAcre;
int: TotalBait;
int: PainPerNetAcre;
int: PainPerLineAcre;
int: MaxPain;

%----- Decision variables ----------------------------------------------------
var 0..TotalAcres: netA;       % acres fished with a net
var 0..TotalAcres: lineA;      % acres fished with a line

%----- Constraints ------------------------------------------------------------
constraint netA + lineA <= TotalAcres;

constraint netA * BaitPerNetAcre + lineA * BaitPerLineAcre <= TotalBait;

constraint netA * PainPerNetAcre + lineA * PainPerLineAcre <= MaxPain;

%----- Objective -------------------------------------------------------------
var int: fishCaught = netA * FishPerNetAcre + lineA * FishPerLineAcre;

solve maximize fishCaught;

%----- Output ---------------------------------------------------------------
output [
  "Net acres: ", show(netA), "\n",
  "Line acres: ", show(lineA), "\n",
  "Total fish caught: ", show(fishCaught), "\n"
];
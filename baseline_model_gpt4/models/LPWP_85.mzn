% Variables
var 0..TotalAcres: NetAcres; % Acres of the lake where the net is used
var 0..TotalAcres: LineAcres; % Acres of the lake where the fishing line is used

% Constraints
constraint NetAcres + LineAcres <= TotalAcres; % Total available acres of the lake
constraint NetAcres*BaitPerNetAcre + LineAcres*BaitPerLineAcre <= TotalBait; % Total available bait
constraint NetAcres*PainPerNetAcre + LineAcres*PainPerLineAcre <= MaxPain; % Maximum tolerable pain for the fisherman

% Objective
var int: TotalFish;
constraint TotalFish = NetAcres*FishPerNetAcre + LineAcres*FishPerLineAcre; % Total fish caught
solve maximize TotalFish;

% Output
output ["Net Acres: ", show(NetAcres), "\n",
        "Line Acres: ", show(LineAcres), "\n",
        "Total Fish: ", show(TotalFish)];
% Parameters
int: TotalAcres; % Total available acres of the lake
int: FishPerNetAcre; % Fish caught per acre using a net
int: FishPerLineAcre; % Fish caught per acre using a fishing line
int: BaitPerNetAcre; % Bait required per acre using a net
int: BaitPerLineAcre; % Bait required per acre using a fishing line
int: TotalBait; % Total available bait
int: PainPerNetAcre; % Pain caused per acre using a net
int: PainPerLineAcre; % Pain caused per acre using a fishing line
int: MaxPain; % Maximum tolerable pain for the fisherman

% Variables
var 0..TotalAcres: net_acres; % Acres fished using a net
var 0..TotalAcres: line_acres; % Acres fished using a fishing line

% Constraints
constraint net_acres + line_acres <= TotalAcres; % Total acres constraint
constraint net_acres*BaitPerNetAcre + line_acres*BaitPerLineAcre <= TotalBait; % Total bait constraint
constraint net_acres*PainPerNetAcre + line_acres*PainPerLineAcre <= MaxPain; % Maximum pain constraint

% Objective
solve maximize net_acres*FishPerNetAcre + line_acres*FishPerLineAcre; % Maximize total fish caught
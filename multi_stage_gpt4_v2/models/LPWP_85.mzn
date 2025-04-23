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
var 0..TotalAcres: NetAcres; % Acres of the lake where the net is used
var 0..TotalAcres: LineAcres; % Acres of the lake where the fishing line is used

% Constraints

% The total acres fished using both methods should not exceed the total available acres
constraint NetAcres + LineAcres <= TotalAcres;

% The total bait used for both methods should not exceed the total available bait
constraint NetAcres*BaitPerNetAcre + LineAcres*BaitPerLineAcre <= TotalBait;

% The total pain caused by both methods should not exceed the maximum tolerable pain
constraint NetAcres*PainPerNetAcre + LineAcres*PainPerLineAcre <= MaxPain;

% Objective
solve maximize NetAcres*FishPerNetAcre + LineAcres*FishPerLineAcre;
% Parameters
int: K; % Number of worker categories
array[1..K] of int: Strength; % Current strength of each worker category
array[1..K] of float: LessOneWaste; % Wastage rate of manpower with less than one year's service in each worker category
array[1..K] of float: MoreOneWaste; % Additional cost per unit more waste in each category
array[1..K] of int: Recruit; % Maximum limit on the manpower that can be recruited in each category
array[1..K] of int: CostRedundancy; % Redundancy payment in each category
int: NumOverman; % Maximum limit more workers over the whole company than are needed
array[1..K] of int: CostOverman; % Extra costs per employee per year for each category of worker
int: NumShortwork; % Maximum number of workers in each category of skill that can be put on short-term working
array[1..K] of int: CostShort; % Cost of short-time working (per employee per year) for each category
array[1..K, 1..K] of int: Requirement; % Estimated manpower requirements of unskilled workers, semi-skilled workers, and skilled workers

% Variables
array[1..K, 1..K] of var 0..max(Recruit): recruit; % Number of recruits in each category
array[1..K, 1..K] of var 0..NumOverman: overman; % Number of over-managed categories
array[1..K, 1..K] of var 0..NumShortwork: shortwork; % Number of short-work categories

% Constraints
constraint forall(i in 1..K)(sum(j in 1..K)(recruit[i,j]) <= Recruit[i]); % Recruitment limit
constraint forall(i in 1..K)(sum(j in 1..K)(overman[i,j]) <= NumOverman); % Overman limit
constraint forall(i in 1..K)(sum(j in 1..K)(shortwork[i,j]) <= NumShortwork); % Shortwork limit
constraint forall(i in 1..K, j in 1..K)(recruit[i,j] + overman[i,j] + shortwork[i,j] == Requirement[i,j]); % Manpower requirement

% Objective
var float: total_cost;
constraint total_cost = sum(i in 1..K, j in 1..K)(recruit[i,j]*CostRedundancy[i] + overman[i,j]*CostOverman[i] + shortwork[i,j]*CostShort[i]);
solve minimize total_cost;

% Output
output ["Total cost: ", show(total_cost), "\n"] ++
["Recruitment: ", show(recruit), "\n"] ++
["Overman: ", show(overman), "\n"] ++
["Shortwork: ", show(shortwork), "\n"];
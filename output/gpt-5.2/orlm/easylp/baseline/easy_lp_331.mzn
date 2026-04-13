% Marketing budget allocation optimization (all data embedded)

% Decision variables: integer units allocated to each channel
var 0..6000: Advertising;
var 0..4000: PR;
var 0..3000: OnlineMarketing;
var 0..7000: OfflineMarketing;

% Constraints
constraint Advertising + PR <= 10000;
constraint OnlineMarketing + OfflineMarketing >= 2000;

% Difference constraints
constraint abs(Advertising - OnlineMarketing) <= 5000;
% "Difference between PR and Offline should not be less than -1000"
% => PR - OfflineMarketing >= -1000
constraint PR - OfflineMarketing >= -1000;

% Objective: minimize total cost
var int: TotalCost =
    5 * Advertising +
    2 * PR +
    3 * OnlineMarketing +
    4 * OfflineMarketing;

solve minimize TotalCost;

output [
  "Advertising=", show(Advertising), "\n",
  "PR=", show(PR), "\n",
  "OnlineMarketing=", show(OnlineMarketing), "\n",
  "OfflineMarketing=", show(OfflineMarketing), "\n",
  "MinimumTotalCost=", show(TotalCost), "\n"
];
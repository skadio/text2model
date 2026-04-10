% Parameters
% Investment option unit costs
int: costX = 7;
int: costY = 3;
int: costZ = 5;

% Diversification / risk / relation / budget limits
int: minDiversification = 10;   % 2*X + Y + Z >= 10
int: maxRiskExposure   = 15;    % X - Y + 2*Z <= 15
int: xMoreThanY        = 3;     % X = Y + 3
int: maxTotalBudget    = 20;    % X + Y + Z <= 20

% Variable bounds (nonnegative whole investments; budget gives an upper bound)
int: maxInv = maxTotalBudget;

% Variables
var 0..maxInv: investX; % whole units invested in option X
var 0..maxInv: investY; % whole units invested in option Y
var 0..maxInv: investZ; % whole units invested in option Z

% Total portfolio cost (upper bound based on maxInv for each option)
var 0..(costX*maxInv + costY*maxInv + costZ*maxInv): totalCost;

% Constraints
% --- Cost aggregation (link decision variables to totalCost) ---
constraint
  totalCost = costX * investX + costY * investY + costZ * investZ;

% --- Diversification constraint: ensure minimum exposure across options ---
constraint
  2 * investX + investY + investZ >= minDiversification;

% --- Risk exposure constraint: cap linear risk expression ---
constraint
  investX - investY + 2 * investZ <= maxRiskExposure;

% --- Relationship constraint: X must be exactly 3 more than Y ---
constraint
  investX = investY + xMoreThanY;

% --- Budget constraint: total units invested cannot exceed available budget ---
constraint
  investX + investY + investZ <= maxTotalBudget;

% Objective
solve minimize totalCost;

% (Optional) output for inspection
output [
  "investX=", show(investX), "\n",
  "investY=", show(investY), "\n",
  "investZ=", show(investZ), "\n",
  "totalCost=", show(totalCost), "\n"
];
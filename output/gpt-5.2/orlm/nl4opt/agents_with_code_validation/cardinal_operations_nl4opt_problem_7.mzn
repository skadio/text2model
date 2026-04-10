% Parameters
% Profit per unit
float: profit_chair = 43.0;
float: profit_dresser = 52.0;

% Weekly resource availability
float: stain_available = 17.0;     % gallons
int: oak_available = 11;           % lengths

% Resource usage per unit
float: stain_per_chair = 1.4;      % gallons per chair
float: stain_per_dresser = 1.1;    % gallons per dresser
int: oak_per_chair = 2;            % lengths per chair
int: oak_per_dresser = 3;          % lengths per dresser


% Variables
% Decision variables: number of items to produce (nonnegative integers)
var 0..oak_available: chairs;    % coarse bound, tightened by constraints below
var 0..oak_available: dressers;  % coarse bound, tightened by constraints below


% Constraints
% Tighten variable bounds implied by oak availability
constraint chairs <= oak_available div oak_per_chair;        % <= floor(11/2)=5
constraint dressers <= oak_available div oak_per_dresser;    % <= floor(11/3)=3

% --- Resource capacity constraints (weekly limits) ---

% Stain usage cannot exceed available gallons
constraint
  stain_per_chair * int2float(chairs) + stain_per_dresser * int2float(dressers)
  <= stain_available;

% Oak wood usage cannot exceed available lengths
constraint
  oak_per_chair * chairs + oak_per_dresser * dressers
  <= oak_available;


% Objective
solve maximize profit_chair * int2float(chairs) + profit_dresser * int2float(dressers);
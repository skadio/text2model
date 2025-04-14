% ============================================================
% SCIENCE FAIR TABLE OPTIMIZATION MODEL
% ============================================================
%
% PROBLEM DESCRIPTION:
% -------------------
% A science fair needs to set up tables for displaying science experiments.
% Two types of tables can be used: circular and rectangular.
%
% - Each table accommodates a certain number of participants and poster boards.
% - Each table type caters to a different number of guests.
% - The space required for each type of table is different.
% - There are minimum requirements for participants and poster boards.
% - The total available space limits the number of tables that can be set up.
%
% OBJECTIVE:
% ----------
% Determine the optimal number of circular and rectangular tables to **maximize**
% the total number of guests that can be accommodated while meeting constraints.
%
% PARAMETERS PROVIDED IN JSON:
% {
%   "TotalSpace": <int>, "MinParticipants": <int>, "MinBoards": <int>,
%   "ParticipantsPerCircular": <int>, "ParticipantsPerRectangular": <int>,
%   "BoardsPerCircular": <int>, "BoardsPerRectangular": <int>,
%   "GuestsPerCircular": <int>, "GuestsPerRectangular": <int>,
%   "SpacePerCircular": <int>, "SpacePerRectangular": <int>
% }
% ============================================================


% -----------------------------
% 1) PARAMETERS
% -----------------------------

int: TotalSpace;          % Total available space
int: MinParticipants;     % Minimum required participants
int: MinBoards;           % Minimum required poster boards

int: ParticipantsPerCircular;  % Participants per circular table
int: ParticipantsPerRectangular; % Participants per rectangular table

int: BoardsPerCircular;    % Poster boards per circular table
int: BoardsPerRectangular; % Poster boards per rectangular table

int: GuestsPerCircular;    % Guests catered per circular table
int: GuestsPerRectangular; % Guests catered per rectangular table

int: SpacePerCircular;     % Space required per circular table
int: SpacePerRectangular;  % Space required per rectangular table


% -----------------------------
% 2) DECISION VARIABLES
% -----------------------------

% The number of circular and rectangular tables to set up
var 0..TotalSpace div SpacePerCircular: CircularTables;
var 0..TotalSpace div SpacePerRectangular: RectangularTables;

% The total number of guests that can be accommodated
var int: TotalGuests;


% -----------------------------
% 3) CONSTRAINTS
% -----------------------------

% (C1) Space Constraint: The total space used cannot exceed the available space.
constraint
    CircularTables * SpacePerCircular + RectangularTables * SpacePerRectangular <= TotalSpace;

% (C2) Participants Constraint: The total number of participants must be at least the required number.
constraint
    CircularTables * ParticipantsPerCircular + RectangularTables * ParticipantsPerRectangular >= MinParticipants;

% (C3) Poster Board Constraint: The total number of poster boards must be at least the required number.
constraint
    CircularTables * BoardsPerCircular + RectangularTables * BoardsPerRectangular >= MinBoards;

% (C4) Total Guests Calculation:
% The total number of guests catered is the sum from both types of tables.
constraint
    TotalGuests = CircularTables * GuestsPerCircular + RectangularTables * GuestsPerRectangular;


% -----------------------------
% 4) OBJECTIVE FUNCTION
% -----------------------------

% Maximize the total number of guests catered.
solve maximize TotalGuests;


% -----------------------------
% 5) OUTPUT
% -----------------------------

% Print the number of each table used and the maximum number of guests catered.
output [
    "Optimal Science Fair Table Setup:\n",
    "  Circular Tables: ", show(CircularTables), "\n",
    "  Rectangular Tables: ", show(RectangularTables), "\n",
    "Maximum Guests Catered: ", show(TotalGuests), "\n"
];
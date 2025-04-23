% Parameters
int: ParticipantsPerCircular; % Number of participants per circular table
int: ParticipantsPerRectangular; % Number of participants per rectangular table
int: BoardsPerCircular; % Number of poster boards per circular table
int: BoardsPerRectangular; % Number of poster boards per rectangular table
int: GuestsPerCircular; % Number of guests per circular table
int: GuestsPerRectangular; % Number of guests per rectangular table
int: SpacePerCircular; % Space required per circular table
int: SpacePerRectangular; % Space required per rectangular table
int: TotalSpace; % Total available space
int: MinParticipants; % Minimum number of participants required
int: MinBoards; % Minimum number of poster boards required

% Variables
var 0..TotalSpace: CircularTables; % Number of circular tables to set up
var 0..TotalSpace: RectangularTables; % Number of rectangular tables to set up

% Constraints

% The total space occupied by the circular and rectangular tables should not exceed the total available space
constraint CircularTables * SpacePerCircular + RectangularTables * SpacePerRectangular <= TotalSpace;

% The total number of participants at the circular and rectangular tables should be at least the minimum required
constraint CircularTables * ParticipantsPerCircular + RectangularTables * ParticipantsPerRectangular >= MinParticipants;

% The total number of poster boards at the circular and rectangular tables should be at least the minimum required
constraint CircularTables * BoardsPerCircular + RectangularTables * BoardsPerRectangular >= MinBoards;

% The number of circular and rectangular tables should be non-negative
constraint CircularTables >= 0;
constraint RectangularTables >= 0;

% Objective
solve maximize CircularTables * GuestsPerCircular + RectangularTables * GuestsPerRectangular;
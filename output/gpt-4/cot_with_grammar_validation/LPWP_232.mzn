% Parameters
int: ParticipantsPerCircular; % Participants per circular table
int: ParticipantsPerRectangular; % Participants per rectangular table
int: BoardsPerCircular; % Poster boards per circular table
int: BoardsPerRectangular; % Poster boards per rectangular table
int: GuestsPerCircular; % Guests per circular table
int: GuestsPerRectangular; % Guests per rectangular table
int: SpacePerCircular; % Space required per circular table
int: SpacePerRectangular; % Space required per rectangular table
int: TotalSpace; % Total available space
int: MinParticipants; % Minimum number of participants required
int: MinBoards; % Minimum number of poster boards required

% Variables
var 0..TotalSpace: CircularTables; % Number of circular tables to set up
var 0..TotalSpace: RectangularTables; % Number of rectangular tables to set up

% Constraints
constraint CircularTables * SpacePerCircular + RectangularTables * SpacePerRectangular <= TotalSpace;
constraint CircularTables * ParticipantsPerCircular + RectangularTables * ParticipantsPerRectangular >= MinParticipants;
constraint CircularTables * BoardsPerCircular + RectangularTables * BoardsPerRectangular >= MinBoards;

% Objective
var int: TotalGuests = CircularTables * GuestsPerCircular + RectangularTables * GuestsPerRectangular;
solve maximize TotalGuests;
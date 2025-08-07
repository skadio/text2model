int: CircularTables;                % Number of circular tables to set up
int: RectangularTables;             % Number of rectangular tables to set up
int: ParticipantsPerCircular;       % Participants per circular table
int: ParticipantsPerRectangular;    % Participants per rectangular table
int: BoardsPerCircular;             % Poster boards per circular table
int: BoardsPerRectangular;          % Poster boards per rectangular table
int: GuestsPerCircular;             % Guests per circular table
int: GuestsPerRectangular;          % Guests per rectangular table
int: SpacePerCircular;              % Space required per circular table
int: SpacePerRectangular;           % Space required per rectangular table
int: TotalSpace;                    % Total available space
int: MinParticipants;               % Minimum number of participants required
int: MinBoards;                     % Minimum number of poster boards required

/* Decision variables */
var 0..CircularTables: numCircular;      % Number of circular tables to set up
var 0..RectangularTables: numRectangular; % Number of rectangular tables to set up

/* Constraints */
constraint (numCircular * SpacePerCircular + numRectangular * SpacePerRectangular) <= TotalSpace; % Space constraint
constraint (numCircular * ParticipantsPerCircular + numRectangular * ParticipantsPerRectangular) >= MinParticipants; % Minimum participants constraint
constraint (numCircular * BoardsPerCircular + numRectangular * BoardsPerRectangular) >= MinBoards; % Minimum boards constraint

/* Objective: Maximize the number of guests */
var int: totalGuests = numCircular * GuestsPerCircular + numRectangular * GuestsPerRectangular;
solve maximize totalGuests;

/* Output */
output [ "Number of Circular Tables: ", show(numCircular), "\n",
         "Number of Rectangular Tables: ", show(numRectangular), "\n",
         "Total Guests: ", show(totalGuests), "\n" ];
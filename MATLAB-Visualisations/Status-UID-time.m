% Parameters for ThingSpeak
channelID = 2747437;
readAPIKey = 'WQ5QPI7WFNF4N7G5';
fieldID = 2
uidFieldID = 1;

% Read data from ThingSpeak
data = thingSpeakRead(channelID, 'Fields', [fieldID, uidFieldID], 'NumPoints', 22, ...
    'ReadKey', readAPIKey, 'OutputFormat', 'table');

% Extract the Status, UID, and Timestamps columns
fieldData = string(data.Status);
uids = string(data.UID);
timestamps = datetime(data.Timestamps, 'InputFormat', 'dd-MM-yyyy hh:mm:ss a');

% Convert UIDs to categorical for scatter plot
uidsCategorical = categorical(uids);

% Separate data by status
validMask = fieldData == "Valid"; % Logical mask for "Valid"
invalidMask = fieldData == "Invalid"; % Logical mask for "Invalid"

% Create scatter plot
figure;
hold on; % Allow multiple plots on the same figure
scatter(timestamps(validMask), uidsCategorical(validMask), 50, 'g', 'filled', 'DisplayName', 'Valid'); % Green for Valid
scatter(timestamps(invalidMask), uidsCategorical(invalidMask), 50, 'r', 'filled', 'DisplayName', 'Invalid'); % Red for Invalid
hold off;

% Add labels and title
xlabel('Time');
ylabel('UIDs');
title('Status of UIDs Over Time');
legend('show'); % Display legend


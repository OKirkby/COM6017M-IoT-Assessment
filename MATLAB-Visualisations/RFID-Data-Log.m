channelID = 2747437;  % ThingSpeak Channel ID
readAPIKey = 'WQ5QPI7WFNF4N7G5';  % ThingSpeak Read API Key

% Fetch data as a table
uidData = thingSpeakRead(channelID, 'Fields', 1, 'NumPoints', 10, 'ReadKey', readAPIKey, 'OutputFormat', 'table');
statusData = thingSpeakRead(channelID, 'Fields', 2, 'NumPoints', 10, 'ReadKey', readAPIKey, 'OutputFormat', 'table');

% Extract UID and Status from the cell arrays
uids = cellfun(@(x) string(x), uidData.UID);
statuses = cellfun(@(x) string(x), statusData.Status);

% Combine the data into a single table
dataTable = table(uidData.Timestamps, uids, statuses, 'VariableNames', {'Timestamp', 'UID', 'Status'});

% Debug: Display fetched data
disp('Recent RFID Scans:');
disp(dataTable);

% Display data visually
figure;
for i = 1:height(dataTable)
    text(0.1, 1 - 0.1*i, ...
        sprintf('Timestamp: %s | UID: %s | Status: %s', ...
        dataTable.Timestamp(i), dataTable.UID(i), dataTable.Status(i)), ...
        'FontSize', 12, 'Interpreter', 'none');
end
axis off;
title('Recent RFID Scans');

% Parameters for ThingSpeak
channelID = 2747437;
readAPIKey = 'WQ5QPI7WFNF4N7G5';
fieldID = 2;
uidFieldID = 1;

% Read non-numeric data with proper output format
data = thingSpeakRead(channelID, 'Fields', [fieldID, uidFieldID], 'NumPoints', 22, ...
    'ReadKey', readAPIKey, 'OutputFormat', 'table');

% Extract columns
fieldData = string(data.Status); 
uids = string(data.UID);
timestamps = datetime(data.Timestamps, 'InputFormat', 'dd-MM-yyyy hh:mm:ss a');

% Get unique UIDs
uniqueUIDs = unique(uids);

% Initialize counts for each UID
validCounts = zeros(size(uniqueUIDs));
invalidCounts = zeros(size(uniqueUIDs));

% Count "Valid" and "Invalid" for each UID
for i = 1:length(uniqueUIDs)
    validCounts(i) = sum(fieldData == "Valid" & uids == uniqueUIDs(i));
    invalidCounts(i) = sum(fieldData == "Invalid" & uids == uniqueUIDs(i));
end

% Bar Chart (UID vs Frequency of Valid/Invalid)
figure;
bar(categorical(uniqueUIDs), [validCounts, invalidCounts], 'grouped');
legend({'Valid', 'Invalid'});
xlabel('UIDs');
ylabel('Frequency');
title('Frequency of Valid and Invalid Values per UID');

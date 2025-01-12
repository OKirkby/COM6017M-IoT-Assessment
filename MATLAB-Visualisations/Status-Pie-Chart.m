% Read data from the ThingSpeak channel
channelID = 2747437;
readAPIKey = 'WQ5QPI7WFNF4N7G5';
fieldID = 2;

% Read non-numeric data with proper output format
data = thingSpeakRead(channelID, 'Fields', fieldID, 'NumPoints', 22, 'ReadKey', readAPIKey, 'OutputFormat', 'table');

% Extract the 'Status' column
fieldData = data.Status; 

% Convert the cell array to a string array
fieldData = string(fieldData);

% Count occurrences of 'Valid' and 'Invalid'
validCount = sum(fieldData == "Valid");
invalidCount = sum(fieldData == "Invalid");

% Check if counts are valid
if validCount + invalidCount == 0
    error('No "Valid" or "Invalid" entries found in the data.');
end

% Prepare data for pie chart
counts = [validCount, invalidCount];
labels = {'Valid', 'Invalid'};

% Create the pie chart
figure;
hPie = pie(counts, labels);
title('Frequency of Valid and Invalid Data');

% Add frequency labels
% hPie contains text and wedge elements alternately

percentLabels = findobj(hPie, 'Type', 'text'); % Find all text labels
frequencies = {['Valid: ' num2str(validCount)], ['Invalid: ' num2str(invalidCount)]};
for k = 1:length(percentLabels)
    percentLabels(k).String = [percentLabels(k).String, newline, frequencies{k}];
end


function generateSimulationData(dt, total_time,funcFL,funcFR,funcRear)
    % This function generates three CSV files for vehicle simulation data.
    % dt is the time step, total_time is the total duration of the simulation,
    % omega is the angular frequency, and func is the function handle for generating displacement.

    % Time vector
    time = 0:dt:total_time;

    % Generating displacement data using the provided function
    displacement_front_right = funcFR(time);
    displacement_front_left = funcFL(time);
    displacement_rear = funcRear(time);

    % Combine time and displacement data
    data_front_right = [time; displacement_front_right]';
    data_front_left = [time; displacement_front_left]';
    data_rear = [time; displacement_rear]';

    % Write data to CSV files
    writeCSVWithHeader('front_right_displacement.csv', data_front_right);
    writeCSVWithHeader('front_left_displacement.csv', data_front_left);
    writeCSVWithHeader('rear_displacement.csv', data_rear);
end
function writeCSVWithHeader(filename, data)
    % Open the file
    fileID = fopen(filename, 'w');
    
    % Write the header
    fprintf(fileID, 'Time, Disp\n');
    
    % Write the data
    fclose(fileID);
    dlmwrite(filename, data, '-append', 'precision', '%.6g', 'delimiter', ',');
end
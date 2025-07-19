Fs = 50e3;

base_path = 'C:\Users\Steven Hess\Documents\rezuktsreal\';
base_prefix = 'July 16_ 2025_';
file_nums = 9:23;

group_names = {
    'Grounded Doors Closed', 
    'Grounded Doors Open', 
    'Ungrounded Doors Closed', 
    'Ungrounded Doors Open', 
    'No Cage'
};

filenames = cell(1, numel(file_nums));
for i = 1:numel(file_nums)
    num_str = sprintf('%02d', file_nums(i));
    filenames{i} = fullfile(base_path, [base_prefix, num_str, '_epks.txt']);
end

group_colors = lines(5);

% Calculate noise and store trials
group_noise = zeros(1,5);
group_trials = cell(1,5);

for g = 1:5
    trials_data = [];
    group_std = zeros(1,3);
    for t = 1:3
        idx = (g - 1) * 3 + t;
        [times, avg, ~] = read_epks(filenames{idx}, Fs);
        times = times(:);
        avg = avg(:);
        trials_data(:,t) = avg * 1e3;
        group_std(t) = std(avg);
    end
    group_trials{g} = trials_data;
    group_noise(g) = mean(group_std);
end

% Sort groups by noise ascending (lowest noise first)
[~, sort_idx] = sort(group_noise);

figure; hold on;

% Plot in reverse order so cleanest on top
for plot_order = 5:-1:1
    g = sort_idx(plot_order);
    trials_data = group_trials{g};
    
    avg_trace = mean(trials_data, 2);
    std_trace = std(trials_data, 0, 2);
    
    upper_bound = min(avg_trace + std_trace, 50);
    lower_bound = max(avg_trace - std_trace, -50);
    
    x_fill = [times; flipud(times)];
    y_fill = [upper_bound; flipud(lower_bound)];
    
    fill(x_fill * 1e3, y_fill, group_colors(g,:), 'FaceAlpha', 0.2, 'EdgeColor', 'none');
    plot(times * 1e3, max(min(avg_trace, 50), -50), 'Color', group_colors(g,:), 'LineWidth', 2, ...
        'DisplayName', group_names{g});
end

xlabel('Time (ms)');
ylabel('Potential (mV)');
ylim([-55 55]);
title('Average Evoked Potentials with ±1 Std Dev (Ordered by Noise)');
legend('Location', 'eastoutside');
grid on;

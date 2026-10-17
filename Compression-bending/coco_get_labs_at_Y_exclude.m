%% Select saved labels nearest to the target loading angles, excluding specified label intervals.

function labs_q = coco_get_labs_at_Y_exclude(bd, Yq, lab_exclude)

Y    = coco_bd_col(bd,'Y');
labs = coco_bd_labs(bd);

labs_q = zeros(size(Yq));

for k = 1:length(Yq)

    % Current target loading angle
    Y_target = Yq(k);

    % Sort candidates by increasing distance from the target angle
    [~, idx_sort] = sort(abs(Y - Y_target), 'ascend');

    found = false;

    for jj = 1:length(idx_sort)

        idx_candidate = idx_sort(jj);
        lab_candidate = labs(idx_candidate);

        % Check whether this label falls within an excluded interval
        in_exclude = false;

        for ee = 1:size(lab_exclude,1)
            lab1 = lab_exclude(ee,1);
            lab2 = lab_exclude(ee,2);

            if lab_candidate >= lab1 && lab_candidate <= lab2
                in_exclude = true;
                break;
            end
        end

        % Select the nearest candidate outside all excluded intervals
        if ~in_exclude
            labs_q(k) = lab_candidate;
            found = true;
            break;
        end

    end

    % Warn if no candidate lies outside the excluded intervals
    if ~found
        warning('Yq(%d) = %.6f has no saved label outside the excluded intervals.', k, Y_target);
        labs_q(k) = NaN;
    end

end

% Remove NaN values and duplicate labels while preserving their order
labs_q = labs_q(~isnan(labs_q));
labs_q = unique(labs_q,'stable');

end
function labs_q = coco_get_labs_at_Y(bd, Yq)

Y    = coco_bd_col(bd,'Y');
labs = coco_bd_labs(bd);

labs_q = zeros(size(Yq));

for k = 1:length(Yq)
    [~,idx] = min(abs(Y - Yq(k)));
    labs_q(k) = labs(idx);
end
labs_q = unique(labs_q,'stable');
end
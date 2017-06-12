%% Average

averages = zeros(size(coherency_matrix, 3));
for window = 1:size(coherency_matrix,3)
    nu_matrix = coherency_matrix(:,:,window) - eye(size(coherency_matrix,1));
    averages(window) = mean(mean(nu_matrix));
%     averages(window) = mean(mean(coherency_matrix(:,:,window)));
end
plot(averages, '-o', 'MarkerIndices', floor(art)+1)

%% Cetrality
coherency_graph = cell(size(coherency_matrix, 3), 1);
for window=1:size(coherency_matrix,3)
    nu_matrix = coherency_matrix(:,:,window) - eye(size(coherency_matrix,1));
    coherency_graph(window) = {graph(nu_matrix)};
    importance_array = [];
    for a = 1:size(nu_matrix, 1)
        for b = 1:size(nu_matrix, 2)
            if (findedge(coherency_graph{window}, a, b)) ~= 0
                importance_array(findedge(coherency_graph{window}, a, b)) = nu_matrix(a,b);
            end
        end
    end
    coherency_graph_centrality(window, :) = centrality(coherency_graph{window}, 'eigenvector', 'importance', importance_array);
end

%% Averages per region


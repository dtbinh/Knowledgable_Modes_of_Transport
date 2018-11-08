function results = validate_GMM_parameters(K, train_labels, train_features, test_labels, test_features)

results = [];

% try out all of the given values of K
n = numel(K);
for p = 1:n
    C = K(p);
    fprintf('----------------------------------------------\n');
    fprintf('step %d / %d : C = %.3f\n', p, n, C);
    fprintf('----------------------------------------------\n');
    
    % train model
    svm_model = train_GMM(train_labels, train_features, C);

    % evaluate on train data
    dval_on_train = evaluate_GMM(svm_model, train_features);
    for i=1:length(dval_on_train)
        if dval_on_train(i) >= 0.5
            dval_on_train(i)=1;
        else
            dval_on_train(i)=-1;
        end
    end
    err_train = mean(sign(dval_on_train) ~= train_labels);
    
    % evaluate on test data
    dval_on_test = evaluate_GMM(svm_model, test_features);
    for i=1:length(dval_on_test)
        if dval_on_test(i) >= 0.5
            dval_on_test(i)=1;
        else
            dval_on_test(i)=-1;
        end
    end
    err_test = mean(sign(dval_on_test) ~= test_labels);
    
    res = struct;
    res.C = C;
    res.model = svm_model;
    res.dval_on_train = dval_on_train;
    res.dval_on_train = dval_on_test;
    res.err_train = err_train;
    res.err_test = err_test;
    
    % store result
    results = [results, res];
end

end
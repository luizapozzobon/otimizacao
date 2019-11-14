function error = loss(target, prediction)
    error = (1/2)*(prediction - target).^2;
end
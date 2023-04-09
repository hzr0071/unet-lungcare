function [loss,gradients,state] = modelLoss(net,input,output)

% Forward data through network.
[Y,state] = forward(net,input);

% Calculate cross-entropy loss.
mask=output>0.03;
tmp=abs(output-Y).*mask;

loss = sum(tmp,'all')./sum(mask,"all");
% loss=sqrt(loss);

% Calculate gradients of loss with respect to learnable parameters.
gradients = dlgradient(loss,net.Learnables);

end
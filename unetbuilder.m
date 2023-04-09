imageSize = [320 320 1];
numClasses = 2;
encoderDepth = 3;
lgraph = unetLayers(imageSize,numClasses,'EncoderDepth',encoderDepth,'NumFirstEncoderFilters',24)
deepNetworkDesigner(lgraph);

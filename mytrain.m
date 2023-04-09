[TrainA,TrainB]=datalod(1,2487);
inputSize = [320,320,1];
% TrainA=shuffle(TrainA);
% TrainB=shuffle(TrainB);

dsTrain = randomPatchExtractionDatastore(TrainA,TrainB, ...
    inputSize(1:2),PatchesPerImage=4);


dsVal = randomPatchExtractionDatastore(TrainA,TrainB,inputSize(1:2));


clear TrainB TrainA;

dsVal=shuffle(dsVal);

miniBatchSize = 8;

mbqTrain = minibatchqueue(dsTrain, ...
    MiniBatchSize=miniBatchSize, ...
    MiniBatchFcn=@concatenateMiniBatch, ...
    PartialMiniBatch="discard", ...
    MiniBatchFormat="SSCB");
mbqVal = minibatchqueue(dsVal, ...
    MiniBatchSize=1, ...
    PartialMiniBatch="discard", ...
    MiniBatchFormat="SSCB" );


numResiduals = 3; 
clear dsTrain 
clear dsVal
figure('Name',"损失");
C = colororder;
lineLossTrain = animatedline(Color=C(2,:));
ylim([0 inf])
xlabel("Iteration")
ylabel("Loss")
grid on
velocity = [];
averageGrad=[];
averageSqGrad=[];

iteration = 0;
valnum=0;
start = tic;

numEpochs = 20;

%% 
% Specify the options for SGDM optimization. Specify an initial learn rate of 
% 0.01 with a decay of 0.01, and momentum 0.9.

learnRate = 0.0005;
decay = 0.99;
momentum = 0.9;
unet=load("trainednet_2022-08-05-05-37-16").net;
% net=dlnetwork(unet);

net=unet;

figs=initfigure(3,["FBP","验证","迭代4"]);
for epoch = 1:numEpochs
     learnRate = learnRate*decay;
        disp(['epoch',num2str(epoch),'_learnrate',num2str(learnRate)]);
    % Shuffle data.
    shuffle(mbqTrain);
    shuffle(mbqVal);
    
    % Loop over mini-batches.
    while hasdata(mbqTrain)
        iteration = iteration + 1;
        valnum=valnum+1;
        % Read mini-batch of data.
        [X,T] = next(mbqTrain);
        
        % Evaluate the model gradients, state, and loss using dlfeval and the
        % modelLoss function and update the network state.
        [loss,gradients,state] = dlfeval(@modelLoss,net,X,T);
        net.State = state;
        
        % Determine learning rate for time-based decay learning rate schedule.
        
        % Update the network parameters using the SGDM optimizer.
%         [net,velocity] = sgdmupdate(net,gradients,velocity,learnRate,momentum);
       [net,averageGrad,averageSqGrad] = adamupdate(net,gradients,averageGrad,averageSqGrad,iteration,learnRate);
        % Display the training progress.
        
        D = duration(0,0,toc(start),Format="hh:mm:ss");
        loss = double(loss);
       
        title("Epoch: " + epoch + ", Elapsed: " + string(D) );
        xlabel("iteration:"+num2str(iteration));
        ylabel("Loss:"+num2str(loss));
        addpoints(lineLossTrain,iteration,loss);
        
        drawnow limitrate
         

        if valnum==1
            
            if hasdata(mbqVal)
            else
                reset(mbqVal)
            end
             [Xv,Tv] = next(mbqVal);
        result = predict(net,Xv);
        result=extractdata(result);
        result=gather(result);
       
        
%         subplot(1,2,1);
        
%         imshow(result,[]);
        imshow(imresize(result,8,'bicubic'),[0,0.25],'Parent',figs{2});
        
        

        
        Tv=extractdata(Tv);
        Tv=gather(Tv);
        
        
        imshow(imresize(Tv,8,'bicubic'),[0,0.25],'Parent',figs{3});


        Xv=extractdata(Xv);
        Xv=gather(Xv);
        
      
        imshow(imresize(Xv,8,'bicubic'),[0,0.25],'Parent',figs{1});
        end
       if valnum==50
           valnum=0;
       end



    end
     if rem(epoch,50)==0
        modelDateTime = string(datetime("now",Format="yyyy-MM-dd-HH-mm-ss"));
       save("checkpoint\checknet"+modelDateTime+".mat",'net');
    end
    
    
end

modelDateTime = string(datetime("now",Format="yyyy-MM-dd-HH-mm-ss"));
    save("trainednet_"+modelDateTime+".mat",'net');








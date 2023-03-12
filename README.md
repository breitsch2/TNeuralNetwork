# TNeuralNetwork
# TNeuralNetwork Component For Delphi

TNeuralNetwork is a general purpose component to be used under Delphi to develop intelligent programs ranging from signal processing to intelligent internet applications. It uses a mixture of Artificial Neural Network Technology to converge to correct solutions with shorter training times. It is quite flexible and accepts different ranges of inputs and outputs defined by the user. Network allows any number of hidden layers and the structure of the network can be visually displayed.

I initially developed the component in 1999. I used the component at different courses to teach the Neural Network and for some scientific studies. Both graduate and undergraduate students used it freely.

I made some very little changes in the code to run with Delphi 10.4 Community edition. 
The scientific paper explains the component in detail as follows:- 
https://www.kau.edu.sa/Files/320/Researches/52692_22998.pdf

# Application Areas for Artificial Neural Networks
Unlike traditional expert systems where a knowledge base and necessary rules have to be defined explicitly, neural networks do not need rules instead they generate rules by learning from shown examples. This makes Artificial Neural Networks general purpose classification tools to be used in pattern recognition and classification systems. Neural networks provide a closer approach to human perception and recognition than traditional computing. When inputs are noisy or incomplete neural networks can still produce reasonable results. Neural networks are used successfully in the following areas.

# Language Processing (Text-to-speech and Speech-to-text applications)

Data compression
Security
Image Recognition
Optical Character Recognition
Texture Detection and Segmentation
Handwriting recognition
Target classification
Industrial inspection
Optimization problems such as travelling salesman problem.
Signal processing (prediction, system modeling, noise filtering etc.)
Financial and Economic Modeling
Control Systems
Servo Control

There are other areas in which neural networks might be applied successfully. They might include intelligent e-commerce applications in which customer buying intentions are recognized from various interactions of the user with the web site.


# Training the Network

## Network Structure
Network property of the component is the most important property and it defines the structure of the network. By setting the values of this property you can define the number of inputs, number of hidden layers and neurons in each hidden layer and the number of outputs. If you want to construct a network as in Figure 1, you can specify 2, 3, 2 and 1 values using object inspector during design time. To define the structure of the network run-time, just add the following code:

````
nn1.Network.clear;

nn1.Network.Add('2');

nn1.Network.Add('3');

nn1.Network.Add('2');

nn1.Network.Add('1');
````

The individual properties set by Network property can be accessed run-time using NumberOfInputs, NumberOfLayers, NumberOfOutputs properties. You can also query number of neurons in each layer by the following code:


````Procedure TForm1.Button3Click(Sender:TObject);

Var

i:integer;

Structure:array of integer; //Array to hold number of neurons in each layer

begin

SetLength(Structure,nn1.Network.count);

for i:=0 to nn1.Network.Count-1 do

Structure[i]:=StrToInt(nn1.Network[i]);

end;
````
 

You can display the graphical structure of the network by calling the DrawNetwork method. The following code displays the network structure and saves the image as bitmap file on the hard disk.

````
nn1.DrawNetwork;

nn1.Picture.SaveToFile('c:\network.bmp');

```` 

If you want to change the size of the neurons in drawing change the NeuronWidth property.

 

## Initialization

After the network structure is defined, the network has to be initialized using the initialize method. You can do this by just writing the following:

````nn1.initialize(true);````

Each initialization step verifies the structure of the network and assigns random values. After initialization, the learning process has to be repeated if the network is not saved. Therefore, before initialization save the network using SaveNetwork method. True parameter in heading initializes the built-in random number generator with a random value (obtained from the system clock) so that each initialization assigns completely different random values to connection weights. False parameter starts initialization with the same set of random values. LearningRate and MomentumRate are two important properties which affect learning curve. Since they are design and run-time properties you can change them during run-time or you can give constant values at the beginning of learning.

Initialized is run-time and read-only property to query whether the network is initialized. This is important because each network structure has to be initialized before training. You can ensure the network is initialized before training by the following simple code:

````if not nn1.Initialized then nn1.Initialize(True);````


## Specifying minimum and maximum output values

You must supply minimums and maximums for both inputs and outputs before start of training. SetInputMinimums, SetInputMaximums, SetOutputMinimums, SetOutputMaximums, SetAllOutputRange and SetAllInputRange methods are available for this purpose. SetAllOutputRange and SetAllInputRange methods are easiest way to perform this. If you want to specify all input-output minimum values to 5 and maximum values to 10 just use the following code:

````
nn1.SetAllInputRange(5,10);
nn1.SetAllOutputRange(5,10);
````

If you want to specify the minimum and maximum values for each individual input or output use SetInputMinimums, SetInputMaximums, SetOutputMinimums and SetOutputMaximums methods instead.


## Training

Training of the network is an iterative process. For each iteration, the network has to be supplied input and corresponding outputs using SetInputs and SetExpectedOutputs methods. The ranges of the inputs and outputs has to conform the ones specified by SetInputMinimums, SetInputMaximums, SetOutputMinimums, SetOutputMaximums, SetAllOutputRange or SetAllInputRange methods. Use the following code to set inputs and desired outputs for the input set:

````
nn1.SetInputs(input);
nn1.SetExpectedOutputs(Desired);
````

After setting inputs and outputs use the Train method as follows:

````
nn1.Train;

````

Following the Train method, RMSError (Rooted Mean Square Error) property is calculated automatically. You can use this value to draw an error graph to track the learning process.


During each iteration of training, a different set of input and corresponding output values are presented to the network. You can stop the iteration after a satisfied RMSError level or a predefined maximum iteration number is reached. It is suggested that the examples should be presented into the network in a random fashion.

 

## After Training

When the learning is achieved, i.e.a satisfactory RMSError level is reached the network must be saved using SaveNetwork method. SaveNetwork method saves the weights and input-output minimums and maximums of the network to use for recognition and other purposes. The next section titled 'Using the Trained Network' describes the recognition stage.



## Summary of the Training

Training of the network is summarized as follows:

Set the maximum and minimum values for both input and output neurons using SetInputMinimums, SetInputMaximums, SetOutputMinimums and SetOutputMaximums individually or using SetAllOutputRange and SetAllInputRange at once.
Supply the input and corresponding output neurons with necessary values using SetInputs and SetExpectedOutputs respectively.
Use Train method to train the network for one cycle (During this, the inputs and outputs specified in the step 2 are used)
Repeat the steps starting at Step 2 each time till an accepted level of RMSError is achieved or a predefined iteration value is reached.


## Using the Trained Network

The network should be saved after it learns all patterns. As soon as the network is trained or loaded from a file it can be used for recognition purposes. To present an unknown input pattern to the network and to get the answer from it follow the steps below:


* Use SetInputs to specify the input neurons
* Use Recall method to query the network
* Use GetOutputs method to get the answer of the network regarding the outputs for the inputs at Step 1
* You can also use RecallOutputs to specify the input pattern and to get the outputs. In this case you don't need to follow the first three steps.

# Properties


# Initialized
Checks whether the network is initialized.

property Initialized:Boolean;

## Description
Use Initialized to check whether the network is initialized. It is especially useful to avoid run-time errors which can occur when inputs or outputs are tried to be set without specifying the network structure.

 

# LearningRate
Defines the range of the changes in the connection weights of the network.

Property LearningRate:Double;

## Description
Use LearningRate to define the amount of the change. If the sample size is small you can specify a higher value. The default value is 0.9.


# MomentumRate
Defines the amount of momentum rate.

Property MomentumRate:Boolean;

## Description
Defines the amount of momentum rate which is a term to improve the learning process. The default value is 0.39.

 
# Network
Specifies the topology of the network.

Property Network:TstringList;

## Description
Holds the structure of the neural network. The first item in the list is the number of input neurons in the input layer and the last one is the number of neurons in output layer. The rest of the list represents the number of hidden layers as well as number of hidden neurons.

 
# NumberOfInputs
Specifies the number of input neurons in input layer.

Property NumberOfInputs:Integer;

## Description
A run-time and read-only property which returns the number of neurons in input layer.

 
# NumberOfInputs
Specifies the number of input neurons in input layer.

Property NumberOfInputs:Integer;

## Description
A run-time and read-only property which returns the number of neurons in input layer.

 

# NumberOfLayers
Specifies the number of layers in the network.

Property NumberOfLayers:Integer;

## Description
A run-time and read-only property which returns the number of layers in the network.


# NumberOfOutputs
Specifies the number of output neurons in output layer.

Property NumberOfOutputs:Integer;

## Description
A run-time and read-only property which returns the number of neurons in output layer.

 

# NumberOfTraining
Gives the number of training since the component is created or initialized.

Property NumberOfTraining:Longint;

## Description
This is a run-time and read-only property which shows the number of training since the last creation or initialization of the component

 
#RMSError
Specifies the Rooted Mean Square Error value after a train cycle.

Property Initialized:Boolean;

## Description
A run-time and read-only property which gives the amount of error after a training cycle.



# Methods

# DrawNetwork
Draws the network.

Procedure DrawNetwork;

## Description
Draws the neural network specified by the network property. See also NeuronWidth property which defines the sizes of the neurons in the network.



# GetOutputs
Calculates the Outputs of the network.

Procedure GetOutputs(Var Outputs: array of double);

## Description
Outputs from the network are computed using this method. Before computing the outputs, inputs have to be presented to network using SetInputs.

 
# GetOutputsFromInputs
Specifies the Rooted Mean Square Error value after a train cycle.

Procedure GetOutputsFromInputs(const Inputs:array of double;
Var Outputs:array of double);

## Description
This method is used to get outputs from a specified input pattern. In case this method is used, no need to use Recall and SetInputs methods.


# Initialize
Initializes the network.

Procedure Initialize(Randomized:Boolean);

## Description
When Initialize method is used, it verifies the structure of the network and assigns random values. Use True value for Randomized if you want to initialize the network connection weights with completely diffferent set of random values.


# LoadNetwork
Loads a neural network from a file.

Function LoadNetwork(FileName:string):Boolean;

## Description
This method loads all connection, bias and other weights from file. It also loads the input- output maximum and minimum values. If the network is loaded successfully the method returns true value.

# Recall
Calculates the outputs of the network for a specified set of input pattern.

Procedure Recall;

## Description
Use this method to calculate the outputs of the network, after the network is trained or a trained network is loaded from file.

 
# SaveNetwork
Saves a neural network to a file.

Function SaveNetwork(FileName:string):Boolean;

## Description
This method saves all connection, bias and other weights to file. It also saves the input- output maximum and minimum values. If the network is saved successfully the method returns true value.

 

# SetAllInputRange
Sets minimum and maximum values for inputs.

Procedure SetAllInputRange(Minimum,Maximum:double);

## Description
Instead of providing minimum and maximum values with SetInputMinimums and SetInputMaximums methods individually, use SetAllInputRange method.

 

# SetAllOutputRange
Sets minimum and maximum values for outputs.

Procedure SetAllOutputRange(Minimum,Maximum:double);

## Description
Instead of providing minimum and maximum values with SetOutputMinimums and SetOutputMaximums methods individually, use SetAllOutputRange method.

 
# SetExpectedOutputs
Provides the network with the expected (desired) outputs.

Procedure SetExpectedOutputs(const Outputs:array of double);

## Description
Before calling Train method, network needs to know the corresponding outputs for a sample set. Use SetExpectedOutputs to present the network desired output values. RMSError is calculated using the expected output values and real output values from network.

 
# SetInputMaximums
Specifies maximum values for inputs.

Procedure SetInputMaximums(const InputMaximums:array of double);

## Description
Maximum values for inputs are specified using SetInputMaximums.

 
# SetInputMinimums
Specifies minimum values for inputs.

Procedure SetInputMinimums(const InputMinimums:array of double);

## Description
Minimum values for inputs are specified using SetInputMinimums.


# SetInputs
Provides the network with the inputs.

Procedure SetInputs(const Inputs:array of double);

## Description
Before calling Train method, network needs to know the inputs for a sample set. Use SetInputs to present the network desired input values. These input values are used for Recall and Train methods.


# SetOutputMaximums
Specifies maximum values for outputs.

Procedure SetOutputMaximums(const OutputMaximums:array of double);

## Description
Maximum values for outputs are specified using SetOutputMaximums.


# SetOutputMinimums
Specifies minimum values for outputs.

Procedure SetOutputMinimums(const OutputMinimums:array of double);

## Description
Minimum values for outputs are specified using SetOutputMinimums.

 

# Train
Trains the network for one iteration.

Procedure Train;

## Description
Trains the network for one cycle. Before calling Train method specify input-output minimums and maximums and give input and output values.



# Properties and Methods which are derived from Tcomponent, Tcontrol and Timage objects are not described here since they are available in help files of Borland products.

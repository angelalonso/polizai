import re
import pickle
import random

import numpy as np
import pandas as pd
import torch
import torch.nn as nn
import torch.nn.functional as F

device = torch.device("cpu")

# read pickle file
pickle_in = open("plots_text.pickle","rb")
movie_plots = pickle.load(pickle_in)

# count of movie plot summaries
len(movie_plots)

# sample random summaries
random.sample(movie_plots, 5)

# clean text
movie_plots = [re.sub("[^a-z' ]", "", i) for i in movie_plots]

# create sequences of length 5 tokens
def create_seq(text, seq_len = 5):
    
    sequences = []

    # if the number of tokens in 'text' is greater than 5
    if len(text.split()) > seq_len:
      for i in range(seq_len, len(text.split())):
        # select sequence of tokens
        seq = text.split()[i-seq_len:i+1]
        # add to the list
        sequences.append(" ".join(seq))

      return sequences

    # if the number of tokens in 'text' is less than or equal to 5
    else:
      
      return [text]

seqs = [create_seq(i) for i in movie_plots]

# merge list-of-lists into a single list
seqs = sum(seqs, [])

# count of sequences
len(seqs)

# create inputs and targets (x and y)
x = []
y = []

for s in seqs:
  x.append(" ".join(s.split()[:-1]))
  y.append(" ".join(s.split()[1:]))

# create integer-to-token mapping
int2token = {}
cnt = 0

for w in set(" ".join(movie_plots).split()):
  int2token[cnt] = w
  cnt+= 1

# create token-to-integer mapping
token2int = {t: i for i, t in int2token.items()}

token2int["the"], int2token[14271]

# set vocabulary size
vocab_size = len(int2token)

def get_integer_seq(seq):
  return [token2int[w] for w in seq.split()]

# convert text sequences to integer sequences
x_int = [get_integer_seq(i) for i in x]
y_int = [get_integer_seq(i) for i in y]

# convert lists to numpy arrays
x_int = np.array(x_int)
y_int = np.array(y_int)

def get_batches(arr_x, arr_y, batch_size):
         
    # iterate through the arrays
    prv = 0
    for n in range(batch_size, arr_x.shape[0], batch_size):
      x = arr_x[prv:n,:]
      y = arr_y[prv:n,:]
      prv = n
      yield x, y




class WordLSTM(nn.Module):
    
    def __init__(self, n_hidden=256, n_layers=4, drop_prob=0.3, lr=0.001):
        super().__init__()

        self.drop_prob = drop_prob
        self.n_layers = n_layers
        self.n_hidden = n_hidden
        self.lr = lr
        
        self.emb_layer = nn.Embedding(vocab_size, 200)

        ## define the LSTM
        self.lstm = nn.LSTM(200, n_hidden, n_layers, 
                            dropout=drop_prob, batch_first=True)
        
        ## define a dropout layer
        self.dropout = nn.Dropout(drop_prob)
        
        ## define the fully-connected layer
        self.fc = nn.Linear(n_hidden, vocab_size)      
    
    def forward(self, x, hidden):
        ''' Forward pass through the network. 
            These inputs are x, and the hidden/cell state `hidden`. '''

        ## pass input through embedding layer
        embedded = self.emb_layer(x)     
        
        ## Get the outputs and the new hidden state from the lstm
        lstm_output, hidden = self.lstm(embedded, hidden)
        
        ## pass through a dropout layer
        out = self.dropout(lstm_output)
        
        #out = out.contiguous().view(-1, self.n_hidden) 
        out = out.reshape(-1, self.n_hidden) 

        ## put "out" through the fully-connected layer
        out = self.fc(out)

        # return the final output and the hidden state
        return out, hidden
    
    
    def init_hidden(self, batch_size):
        ''' initializes hidden state '''
        # Create two new tensors with sizes n_layers x batch_size x n_hidden,
        # initialized to zero, for hidden state and cell state of LSTM
        weight = next(self.parameters()).data

        # if GPU is available
        if (torch.cuda.is_available()):
          hidden = (weight.new(self.n_layers, batch_size, self.n_hidden).zero_().cuda(),
                    weight.new(self.n_layers, batch_size, self.n_hidden).zero_().cuda())
        
        # if GPU is not available
        else:
          hidden = (weight.new(self.n_layers, batch_size, self.n_hidden).zero_(),
                    weight.new(self.n_layers, batch_size, self.n_hidden).zero_())
        
        return hidden


# instantiate the model
net = WordLSTM()

# push the model to GPU (avoid it if you are not using the GPU)
#net.cuda()

print(net)


def train(net, epochs=10, batch_size=32, lr=0.001, clip=1, print_every=32):
    
    # optimizer
    opt = torch.optim.Adam(net.parameters(), lr=lr)
    
    # loss
    criterion = nn.CrossEntropyLoss()
    
    # push model to GPU
    net.cuda()
    
    counter = 0

    net.train()

    for e in range(epochs):

        # initialize hidden state
        h = net.init_hidden(batch_size)
        
        for x, y in get_batches(x_int, y_int, batch_size):
            counter+= 1
            
            # convert numpy arrays to PyTorch arrays
            inputs, targets = torch.from_numpy(x), torch.from_numpy(y)
            
            # push tensors to GPU
            inputs, targets = inputs.cuda(), targets.cuda()

            # detach hidden states
            h = tuple([each.data for each in h])

            # zero accumulated gradients
            net.zero_grad()
            
            # get the output from the model
            output, h = net(inputs, h)
            
            # calculate the loss and perform backprop
            loss = criterion(output, targets.view(-1))

            # back-propagate error
            loss.backward()

            # `clip_grad_norm` helps prevent the exploding gradient problem in RNNs / LSTMs.
            nn.utils.clip_grad_norm_(net.parameters(), clip)

            # update weigths
            opt.step()            
            
            if counter % print_every == 0:
            
              print("Epoch: {}/{}...".format(e+1, epochs),
                    "Step: {}...".format(counter))



def train(net, epochs=10, batch_size=32, lr=0.001, clip=1, print_every=32):
    
    # optimizer
    opt = torch.optim.Adam(net.parameters(), lr=lr)
    
    # loss
    criterion = nn.CrossEntropyLoss()
    
    # push model to GPU
    #net.cuda()
    
    counter = 0

    net.train(device=device)

    for e in range(epochs):

        # initialize hidden state
        h = net.init_hidden(batch_size)
        
        for x, y in get_batches(x_int, y_int, batch_size):
            counter+= 1
            
            # convert numpy arrays to PyTorch arrays
            inputs, targets = torch.from_numpy(x), torch.from_numpy(y)
            
            # push tensors to GPU
            inputs, targets = inputs.cuda(), targets.cuda()

            # detach hidden states
            h = tuple([each.data for each in h])

            # zero accumulated gradients
            net.zero_grad()
            
            # get the output from the model
            output, h = net(inputs, h)
            
            # calculate the loss and perform backprop
            loss = criterion(output, targets.view(-1))

            # back-propagate error
            loss.backward()

            # `clip_grad_norm` helps prevent the exploding gradient problem in RNNs / LSTMs.
            nn.utils.clip_grad_norm_(net.parameters(), clip)

            # update weigths
            opt.step()            
            
            if counter % print_every == 0:
            
              print("Epoch: {}/{}...".format(e+1, epochs),
                    "Step: {}...".format(counter))


# train the model
train(net, batch_size = 32, epochs=20, print_every=256)








# predict next token
def predict(net, tkn, h=None):
         
  # tensor inputs
  x = np.array([[token2int[tkn]]])
  inputs = torch.from_numpy(x)
  
  # push to GPU
  inputs = inputs.cuda()

  # detach hidden state from history
  h = tuple([each.data for each in h])

  # get the output of the model
  out, h = net(inputs, h)

  # get the token probabilities
  p = F.softmax(out, dim=1).data

  p = p.cpu()

  p = p.numpy()
  p = p.reshape(p.shape[1],)

  # get indices of top 3 values
  top_n_idx = p.argsort()[-3:][::-1]

  # randomly select one of the three indices
  sampled_token_index = top_n_idx[random.sample([0,1,2],1)[0]]

  # return the encoded value of the predicted char and the hidden state
  return int2token[sampled_token_index], h


# function to generate text
def sample(net, size, prime='it is'):
        
    # push to GPU
    net.cuda()
    
    net.eval()

    # batch size is 1
    h = net.init_hidden(1)

    toks = prime.split()

    # predict next token
    for t in prime.split():
      token, h = predict(net, t, h)
    
    toks.append(token)

    # predict subsequent tokens
    for i in range(size-1):
        token, h = predict(net, toks[-1], h)
        toks.append(token)

    return ' '.join(toks)

sample(net, 15, prime = "one of the")
sample(net, 15, prime = "as soon as")
sample(net, 15, prime = "they")

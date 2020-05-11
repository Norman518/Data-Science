import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

training_df = pd.read_csv('data/Google_Stock_Price_Train.csv')
training_set = training_df['Open'].values.reshape(-1,1)

test_df = pd.read_csv('data/Google_Stock_Price_Test.csv')
test_set = test_df['Open'].values.reshape(-1,1)

total_df = pd.concat((training_df['Open'], test_df['Open']), axis = 0)
inputs = total_df[len(total_df) - len(test_df) - 60:].values.reshape(-1,1)

from sklearn.preprocessing import MinMaxScaler
sc = MinMaxScaler(feature_range = (0,1))
training_set_scaled = sc.fit_transform(training_set)   
inputs_scaled = sc.transform(inputs)

X_train = []
y_train = []

X_test = []

for i in range(60, 1258):
    X_train.append(training_set_scaled[i-60:i, 0])
    y_train.append(training_set_scaled[i, 0])
X_train, y_train = np.array(X_train), np.array(y_train)
X_train = np.reshape(X_train, (X_train.shape[0], X_train.shape[1], 1))  

for i in range(60, 80):
    X_test.append(inputs_scaled[i-60:i, 0])
X_test = np.array(X_test)
X_test = np.reshape(X_test, (X_test.shape[0], X_test.shape[1], 1))     

from keras.models import Sequential
from keras.layers import Dense, LSTM, Dropout

regressor = Sequential()

regressor.add(LSTM(units = 50, return_sequences = True, input_shape = (X_train.shape[1], 1)))
regressor.add(Dropout(0.2))

regressor.add(LSTM(units = 50, return_sequences = True))
regressor.add(Dropout(0.2))

regressor.add(LSTM(units = 50, return_sequences = True))
regressor.add(Dropout(0.2))

regressor.add(LSTM(units = 50))
regressor.add(Dropout(0.2))

regressor.add(Dense(1))

regressor.compile(optimizer = 'adam', loss = 'mean_squared_error')

regressor.fit(X_train, y_train, epochs = 100, batch_size = 32)

predictions = regressor.predict(X_test)
predictions = sc.inverse_transform(predictions)

plt.plot(test_set,color = 'red', label='Google Stock Price')
plt.plot(predictions,color='blue',label='Predicted Google Stock Price')
plt.title('Google Stock Price Predictions')
plt.xlabel('Time')
plt.ylabel('Price')
plt.legend()
plt.show()
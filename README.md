# Maya

A sample Flutter project that lets the user send money and view the transactions history. The app 
does not user any API to store and fetch data, instead using https://jsonplaceholder.typicode.com/ 
to simulate the API calls but storing the sent money to local storage which will be used in the 
transactions history screen.

- Login
  - The entry point in the app. After a successful login, the user is taken to the home screen.
- Home
  - The home screen shows the user's account balance and buttons to go to the send money and 
  transactions screens.
- Send Money
    - The send money screen allows the user to send money to another user. The user can select the
  recipient from a list of users and enter the amount to send.
- Transactions
    - The transactions screen shows a list of transactions made by the user. The user can click on
  a transaction to see more details.
  
## Getting Started

This project is a starting point for the Flutter application.

## Running the app
- Ensure you are in the project directory:
- To run the app, execute the following command:
    - `flutter run`
    - This will execute all the unit tests in the test directory.

## Running the Unit Tests
- Ensure you are in the project directory:
- To run the tests, execute the following command
    - `flutter test`
    - This will execute all the unit tests in the test directory.

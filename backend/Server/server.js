const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const app = express();

app.use(bodyParser.json());

// MongoDB connection setup...

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

mongoose.connect('mongodb://localhost:27017/yourDatabaseName', { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log('MongoDB connected'))
  .catch(err => console.log(err));

  const Schema = mongoose.Schema;

  const userSchema = new Schema({
    username: String,
    userId: { type: String, unique: true }
  });
  
  const recordSchema = new Schema({
    userId: String,
    item: String,
    timeSpent: Number
  });
  
  const User = mongoose.model('User', userSchema);
  const Record = mongoose.model('Record', recordSchema);

  // Add a new user
app.post('/users', (req, res) => {
  const newUser = new User(req.body);
  newUser.save().then(user => res.json(user)).catch(err => res.status(400).json('Error: ' + err));
});

// Add a new record
app.post('/records', (req, res) => {
  const newRecord = new Record(req.body);
  newRecord.save().then(record => res.json(record)).catch(err => res.status(400).json('Error: ' + err));
});

// Fetch records for a user
app.get('/records/:userId', (req, res) => {
  Record.find({ userId: req.params.userId })
    .then(records => res.json(records))
    .catch(err => res.status(400).json('Error: ' + err));
});

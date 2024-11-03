import express from 'express';
import dotenv from 'dotenv';
import bodyParser from 'body-parser';
import morgan from 'morgan';
import cors from 'cors';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// middleware configuration
app.use(bodyParser.json());
app.use(morgan('tiny'));
app.use(cors())
app.options("*", cors());


app.get('/', (req, res) => {
  res.send('Hello World!')
})

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
})


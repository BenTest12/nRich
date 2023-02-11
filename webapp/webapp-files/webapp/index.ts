import express, { Request, Response } from 'express';
import axios from 'axios';

const app = express();

app.get('/coin', async (req: Request, res: Response) => {
  try {
    const response = await axios.get('https://api.coingecko.com/api/v3/coins/list');
    const coins = response.data;
    const randomIndex = Math.floor(Math.random() * coins.length);
    const randomCoin = coins[randomIndex];

    const coinData = await axios.get(`https://api.coingecko.com/api/v3/coins/${randomCoin.id}`);
    const html = `
      <h1>${coinData.data.name}</h1>
      <p>Value: ${coinData.data.market_data.current_price.usd} USD</p>
    `;

    res.send(html);
  } catch (error) {
    res.status(500).send(error);
  }
});

app.listen(4444, () => {
  console.log('Server started on port 4444');
});

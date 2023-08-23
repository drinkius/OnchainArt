# OnchainArt NFTs

[XDC Apothem Testnet deployment, interact with it through the script deploy.js](https://explorer.apothem.network/address/xdc479c628cc6c557861e630c9575a6eac2f076ab59#transactions)

[Goerli deploy where you can play around with minting your own NFTs](https://goerli.etherscan.io/address/0x912aa471edf134fe9e175b27dc40f43511b1f56a#writeContract)

[NFT Collection on opensea](https://testnets.opensea.io/collection/onchainart-8)

This NFT collection is fully on-chain including the artwork. The NFTs can easily be viewed on any marketplace like OpenSea, all the formats are correct and are parsed correctly

## Deployment
In order yo deploy your own version of the collection  to XDC Apothem Network (remember to create a .env file with your own funded private key, see .env.example):

```shell
npm install
npm run deploy:apothem
```

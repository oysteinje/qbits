# How to set up this site 
Add content
```
ipfs add -r .
```

Use the hash of the directory and publish it to ipns
```
ipfs name publish /ipfs/<hash of directory>
```

When a file is modified add it using 
```
ipfs add -r .
```

Publish it using the same ipns as before. This project use ipns k51qzi5uqu5dkb2h7m398ia0mo8og2uav3p1e93pplyyxkrsdv08goteb11te7

```
ipfs name publish k51qzi5uqu5dkb2h7m398ia0mo8og2uav3p1e93pplyyxkrsdv08goteb11te7
```

The content can be accessed from the following URLS:

[IPFS gateway](https://gateway.ipfs.io/ipns/k51qzi5uqu5dkb2h7m398ia0mo8og2uav3p1e93pplyyxkrsdv08goteb11te7)

[WWW redirect](https://ipfs.qbits.no)
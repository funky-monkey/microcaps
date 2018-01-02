# Microcaps

<img src="https://github.com/funky-monkey/microcaps/raw/master/Icon.png" width="150" height="150" align="middle">

No need for manually calculating microcaps when doing research on new coins/tokens

After reading [this article](https://medium.com/@daytradernik/picking-out-microcaps-101-2215a5782691) I decided to create this small app to help me with step 1. Double clicking a row will open the corresponing coin/token page on [coinmarketcap](coinmarketcap.com).

### What is implemented?

* Order by market cap in $. 
*  Note down all the coins below this mark with a low to medium coin supply i.e less than 50m. For all of these, also note down their 24H volume in $. 
* Cross out the coins with a lower than 2% market cap to volume ratio (if X has a market cap of $100k, it’s 24H volume should be $2000 or more). This is simply to filter the microcaps that are getting a decent amount of attention. 
* From these remaining coins, cross out all the coins that have a far greater total supply than their circulating supply (this is usually indicative of a large premine, and fuck that noise — there’s plenty of coins to pick up without this added liability). 
* The ones you’re left with (there’s usually quite a few) are the ones you need to do further research on.

### How do I run this?

You can find the latest version under [the Releases tab](https://github.com/funky-monkey/microcaps/releases). Here you'll find a versioned .zip file. Unpack this and drag/copy the the .app file to your `/Applications` folder on your Mac. 

If you get an dialog like this:

<img src="https://github.com/funky-monkey/microcaps/raw/master/permissions.png" width="400" align="middle">

then go to your Mac's `Settings > Security and Privacy` and press the `Open anyway` button. You can now enjoy the app.

Hope this helps anyone :) 

Any feature requests are welcome!
